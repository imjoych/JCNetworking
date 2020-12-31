//
//  JCNetworkManager.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCNetworkManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JCNetworkConfig.h"

@implementation JCNetworkManager

+ (NSURLSessionTask *)get:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                 progress:(JCNetworkProgressBlock)progress
               completion:(JCNetworkCompletionBlock)completion
{
    return [self get:urlString parameters:parameters config:nil progress:progress completion:completion];
}

+ (NSURLSessionTask *)get:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                   config:(JCNetworkConfig *)config
                 progress:(JCNetworkProgressBlock)progress
               completion:(JCNetworkCompletionBlock)completion
{
    AFHTTPSessionManager *manager = [self sessionManager:urlString config:config];
    if (!manager) {
        return nil;
    }
    return [manager GET:[self requestUrl:urlString parameters:parameters] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(downloadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
        [self cancelTask:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
        [self cancelTask:task];
    }];
}

+ (NSURLSessionTask *)post:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                  progress:(JCNetworkProgressBlock)progress
                completion:(JCNetworkCompletionBlock)completion
{
    return [self post:urlString
    parameters:parameters config:nil progress:progress completion:completion];
}

+ (NSURLSessionTask *)post:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                    config:(JCNetworkConfig *)config
                  progress:(JCNetworkProgressBlock)progress
                completion:(JCNetworkCompletionBlock)completion
{
    AFHTTPSessionManager *manager = [self sessionManager:urlString config:config];
    if (!manager) {
        return nil;
    }
    return [manager POST:urlString parameters:[self filteredParameters:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
        [self cancelTask:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
        [self cancelTask:task];
    }];
}

+ (NSURLSessionTask *)upload:(NSString *)urlString
                  parameters:(NSDictionary *)parameters
                      config:(JCNetworkConfig *)config
                    progress:(JCNetworkProgressBlock)progress
                  completion:(JCNetworkCompletionBlock)completion
{
    AFHTTPSessionManager *manager = [self sessionManager:urlString config:config];
    if (!manager) {
        return nil;
    }
    return [manager POST:urlString parameters:[self filteredParameters:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formData) {
            [config appendUploadFilePathBlock:^(NSString *filePath, NSString *operationName) {
                if (![filePath isKindOfClass:[NSString class]]
                    || ![operationName isKindOfClass:[NSString class]]) {
                    return;
                }
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                           name:operationName
                                          error:nil];
            }];
            [config appendUploadFileDataBlock:^(NSData *fileData, NSString *operationName, NSString *fileName, NSString *mimeType) {
                if (![fileData isKindOfClass:[NSData class]]
                    || ![operationName isKindOfClass:[NSString class]]
                    || ![fileName isKindOfClass:[NSString class]]
                    || ![mimeType isKindOfClass:[NSString class]]) {
                    return;
                }
                [formData appendPartWithFileData:fileData
                                            name:operationName
                                        fileName:fileName
                                        mimeType:mimeType];
            }];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
        [self cancelTask:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
        [self cancelTask:task];
    }];
}

+ (void)cancelTask:(NSURLSessionTask *)task
{
    if (![task isKindOfClass:[NSURLSessionTask class]]) {
        return;
    }
    if ([task respondsToSelector:@selector(cancel)]) {
        [task cancel];
    }
}

+ (void)cleanRequestConfig:(NSString *)hostUrl
{
    NSURL *url = [self validUrl:hostUrl];
    if (!url) {
        return;
    }
    AFHTTPSessionManager *manager = [self existSessionManager:url];
    if (!manager) {
        return;
    }
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
}

+ (AFHTTPSessionManager *)existSessionManager:(NSURL *)url
{
    for (AFHTTPSessionManager *sessionManager in self.sessionManagers) {
        if ([sessionManager.baseURL isEqual:url.baseURL]) {
            return sessionManager;
        }
    }
    return nil;
}

+ (NSURL *)validUrl:(NSString *)urlString
{
    if (![urlString isKindOfClass:[NSString class]] || urlString.length < 1) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if (url.baseURL) {
        return url;
    }
    return nil;
}

+ (AFHTTPSessionManager *)sessionManager:(NSString *)urlString
                                  config:(JCNetworkConfig *)config
{
    NSURL *url = [self validUrl:urlString];
    if (!url) {
        return nil;
    }
    AFHTTPSessionManager *manager = [self existSessionManager:url];
    if (!manager) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url.baseURL];
        [self setResponseSerializer:manager config:config];
        [self.sessionManagers addObject:manager];
    }
    [self setRequestSerializer:manager config:config];
    return manager;
}

+ (NSMutableArray *)sessionManagers
{
    static NSMutableArray *sessionManagers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManagers = [NSMutableArray array];
    });
    return sessionManagers;
}

+ (void)setRequestSerializer:(AFHTTPSessionManager *)manager
                      config:(JCNetworkConfig *)config
{
    if (!config) {
        return;
    }
    manager.requestSerializer.timeoutInterval = config.requestTimeoutInterval;
    NSDictionary *headerFields = config.HTTPHeaderFields;
    for (NSString *field in headerFields.allKeys) {
        [manager.requestSerializer setValue:headerFields[field] forHTTPHeaderField:field];
    }
}

+ (void)setResponseSerializer:(AFHTTPSessionManager *)manager
                       config:(JCNetworkConfig *)config
{
    if (!config) {
        return;
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 重新初始化，不限制Content-Type
    NSSet<NSData *> *pinnedCertificates = config.pinnedCertificates;
    AFSSLPinningMode pinningMode = (AFSSLPinningMode)config.SSLPinningMode;
    if (pinnedCertificates && pinningMode != AFSSLPinningModeNone) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:pinningMode];
        securityPolicy.pinnedCertificates = pinnedCertificates;
        securityPolicy.allowInvalidCertificates = config.allowInvalidCertificates;
        securityPolicy.validatesDomainName = config.validatesDomainName;
        manager.securityPolicy = securityPolicy;
    }
}

+ (NSString *)requestUrl:(NSString *)requestUrl parameters:(NSDictionary *)parameters
{
    if (parameters.count > 0) {
        NSString *parametersString = AFQueryStringFromParameters(parameters);
        NSString *symbol = [requestUrl containsString:@"?"] ? @"&":@"?";
        requestUrl = [NSString stringWithFormat:@"%@%@%@", requestUrl, symbol, parametersString];
    }
    return requestUrl;
}

/// The values of parameters are filtered which types are kind of NSNull class.
+ (NSDictionary *)filteredParameters:(NSDictionary *)parameters
{
    if (![parameters isKindOfClass:[NSDictionary class]] || parameters.count < 1) {
        return nil;
    }
    __block NSMutableDictionary *filteredDict = [NSMutableDictionary dictionary];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            return;
        }
        filteredDict[key] = obj;
    }];
    return filteredDict;
}

@end
