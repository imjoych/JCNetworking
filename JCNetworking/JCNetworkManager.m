//
//  JCNetworkManager.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCNetworkManager.h"
#import "JCBaseRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface JCNetworkManager ()

@property (nonatomic, strong) NSMutableDictionary *requestsDict;
@property (nonatomic, strong) NSMutableDictionary *tasksDict;
@property (nonatomic, strong) NSMutableArray *sessionManagers;

@end

@implementation JCNetworkManager

- (instancetype)init
{
    if (self = [super init]) {
        _requestsDict = [NSMutableDictionary dictionary];
        _tasksDict = [NSMutableDictionary dictionary];
        _sessionManagers = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static JCNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[JCNetworkManager alloc] init];
    });
    return sharedManager;
}

- (void)startRequest:(JCBaseRequest *)request
{
    if (!request) {
        return;
    }
    
    NSString *key = [self requestKey:request];
    // Remove duplicated request if needed.
    if ([self.requestsDict.allKeys containsObject:key]) {
        JCBaseRequest *duplicatedRequest = self.requestsDict[key];
        [self stopRequest:duplicatedRequest];
    }
    
    NSURLSessionTask *task = [self resumeTaskWithRequest:request];
    if (task) {
        @synchronized(self.requestsDict) {
            self.tasksDict[key] = task;
            self.requestsDict[key] = request;
        }
    }
}

- (void)stopRequest:(JCBaseRequest *)request
{
    if (!request) {
        return;
    }
    
    NSString *key = [self requestKey:request];
    NSURLSessionTask *requestTask = self.tasksDict[key];
    if ([requestTask respondsToSelector:@selector(cancel)]) {
        [requestTask cancel];
    }
    @synchronized(self.requestsDict) {
        [self.tasksDict removeObjectForKey:key];
        [self.requestsDict removeObjectForKey:key];
    }
}

- (void)stopAllRequests
{
    NSMutableDictionary *requestsDict = [NSMutableDictionary dictionaryWithDictionary:self.requestsDict];
    for (NSString *key in requestsDict.allKeys) {
        JCBaseRequest *request = requestsDict[key];
        [request stopRequest];
    }
    [requestsDict removeAllObjects];
    [self.sessionManagers removeAllObjects];
}

- (void)startRequest:(JCBaseRequest *)request
         decodeClass:(Class)decodeClass
          completion:(JCRequestCompletionBlock)completion
{
    [request startRequestWithDecodeClass:decodeClass completion:completion];
}

- (void)startRequest:(JCBaseRequest *)request
         decodeClass:(Class)decodeClass
            progress:(JCRequestProgressBlock)progress
          completion:(JCRequestCompletionBlock)completion
{
    [request startRequestWithDecodeClass:decodeClass
                                progress:progress
                              completion:completion];
}

#pragma mark -

- (NSURLSessionTask *)resumeTaskWithRequest:(JCBaseRequest *)request
{
    AFHTTPSessionManager *manager = [self sessionManagerForRequest:request];
    if (!manager) {
        return nil;
    }
    [self setRequestSerializerWithManager:manager
                                  request:request];
    NSURLSessionTask *task = nil;
    switch ([request requestMethod]) {
        case JCRequestMethodGET:
        {
            task = [manager GET:[self requestUrl:[request requestUrl] parameters:[request filteredDictionary]]
                     parameters:nil
                       progress:^(NSProgress * _Nonnull downloadProgress) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if (request.progressBlock) {
                                   request.progressBlock(downloadProgress);
                               }
                           });
                       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           [request parseResponseObject:responseObject error:nil];
                           [request stopRequest];
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           [request parseResponseObject:nil error:error];
                           [request retryRequestIfNeeded:error];
                       }];
        }
            break;
        case JCRequestMethodPOST:
        {
            if ([request uploadFileNeeded]) {
                task = [self uploadWithManager:manager request:request];
            } else {
                task = [manager POST:[request requestUrl]
                          parameters:[request filteredDictionary]
                            progress:^(NSProgress * _Nonnull uploadProgress) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (request.progressBlock) {
                                        request.progressBlock(uploadProgress);
                                    }
                                });
                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                [request parseResponseObject:responseObject error:nil];
                                [request stopRequest];
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                [request parseResponseObject:nil error:error];
                                [request retryRequestIfNeeded:error];
                            }];
            }
        }
            break;
    }
    return task;
}

- (AFHTTPSessionManager *)sessionManagerForRequest:(JCBaseRequest *)request
{
    NSString *baseUrl = [request baseUrl];
    if (!baseUrl || baseUrl.length < 1) {
        return nil;
    }
    AFHTTPSessionManager *manager = nil;
    for (AFHTTPSessionManager *sessionManager in self.sessionManagers) {
        if ([sessionManager.baseURL.absoluteString isEqualToString:baseUrl]) {
            manager = sessionManager;
            break;
        }
    }
    if (!manager) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //重新初始化，不限制Content-Type
        NSSet<NSData *> *pinnedCertificates = [request pinnedCertificates];
        AFSSLPinningMode pinningMode = (AFSSLPinningMode)[request SSLPinningMode];
        if (pinnedCertificates && pinningMode != AFSSLPinningModeNone) {
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:pinningMode];
            securityPolicy.pinnedCertificates = pinnedCertificates;
            securityPolicy.allowInvalidCertificates = [request allowInvalidCertificates];
            securityPolicy.validatesDomainName = [request validatesDomainName];
            manager.securityPolicy = securityPolicy;
        }
        [self.sessionManagers addObject:manager];
    }
    return manager;
}

- (NSString *)requestKey:(JCBaseRequest *)request
{
    NSString *identifier = [request requestIdentifier];
    if (identifier.length > 0) {
        return identifier;
    }
    return [NSString stringWithFormat:@"%@", @([request hash])];
}

- (NSString *)requestUrl:(NSString *)requestUrl parameters:(NSDictionary *)parameters
{
    if (parameters.count > 0) {
        NSString *parametersString = AFQueryStringFromParameters(parameters);
        NSString *symbol = [requestUrl containsString:@"?"] ? @"&":@"?";
        requestUrl = [NSString stringWithFormat:@"%@%@%@", requestUrl, symbol, parametersString];
    }
    return requestUrl;
}

- (void)setRequestSerializerWithManager:(AFHTTPSessionManager *)manager
                                request:(JCBaseRequest *)request
{
    manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    NSDictionary *headerFields = [request HTTPHeaderFields];
    for (NSString *field in headerFields) {
        [manager.requestSerializer setValue:headerFields[field] forHTTPHeaderField:field];
    }
}

#pragma mark - upload request

- (NSURLSessionDataTask *)uploadWithManager:(AFHTTPSessionManager *)manager
                                    request:(JCBaseRequest *)request
{
    return [manager POST:[request requestUrl] parameters:[request filteredDictionary] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formData) {
            [request appendUploadFilePathBlock:^(NSString *filePath, NSString *operationName) {
                if (![filePath isKindOfClass:[NSString class]]
                    || ![operationName isKindOfClass:[NSString class]]) {
                    return;
                }
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                           name:operationName
                                          error:nil];
            }];
            [request appendUploadFileDataBlock:^(NSData *fileData, NSString *operationName, NSString *fileName) {
                if (![fileData isKindOfClass:[NSData class]]
                    || ![operationName isKindOfClass:[NSString class]]
                    || ![fileName isKindOfClass:[NSString class]]) {
                    return;
                }
                [formData appendPartWithFileData:fileData
                                            name:operationName
                                        fileName:fileName
                                        mimeType:@"application/octet-stream"];
            }];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request.progressBlock) {
                request.progressBlock(uploadProgress);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [request parseResponseObject:responseObject error:nil];
        [request stopRequest];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [request parseResponseObject:nil error:error];
        [request retryRequestIfNeeded:error];
    }];
}

@end
