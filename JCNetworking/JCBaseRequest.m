//
//  JCBaseRequest.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCBaseRequest.h"
#import "JCNetworkManager.h"

@interface JCBaseRequest () {
    JCRequestCompletionBlock _completionBlock;
    JCRequestProgressBlock _progressBlock;
    NSUInteger _retryTimes;
    NSMutableArray<NSArray *> *_uploadFilePathList;
    NSMutableArray<NSArray *> *_uploadFileDataList;
    NSDictionary *_params;
}

@end

@implementation JCBaseRequest

- (instancetype)init
{
    if (self = [super init]) {
        _retryTimes = [self timeoutRetryTimes];
    }
    return self;
}

#pragma mark - Protocol

- (void)startRequestWithCompletion:(JCRequestCompletionBlock)completion
{
    [self startRequestWithProgress:nil
                        completion:completion];
}

- (void)startRequestWithProgress:(JCRequestProgressBlock)progress
                      completion:(JCRequestCompletionBlock)completion
{
    _progressBlock = progress;
    _completionBlock = completion;
    [[JCNetworkManager sharedManager] startRequest:self];
}

- (void)stopRequest
{
    _completionBlock = nil;
    _progressBlock = nil;
    _uploadFilePathList = nil;
    _uploadFileDataList = nil;
    [[JCNetworkManager sharedManager] stopRequest:self];
}

- (JCRequestCompletionBlock)completionBlock
{
    return _completionBlock;
}

- (JCRequestProgressBlock)progressBlock
{
    return _progressBlock;
}

- (BOOL)retryRequestIfNeeded:(NSError *)error
{
    if (_retryTimes < 1
        || error.code != NSURLErrorTimedOut) {
        return NO;
    }
    _retryTimes--;
    return YES;
}

- (NSDictionary *)filteredDictionary
{
    NSDictionary *params = _params;
    if (params.count < 1) {
        return params;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSString *key in params.allKeys) {
        id value = params[key];
        if (value && [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        [parameters setValue:value forKey:key];
    }
    return parameters;
}

- (void)setParamsDictionary:(NSDictionary *)params
{
    _params = params;
}

#pragma mark - Subclass implementation methods

- (JCRequestMethod)requestMethod
{
    return JCRequestMethodGET;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (NSString *)requestUrl
{
    return @"";
}

- (NSString *)baseUrl
{
    return @"";
}

- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error
{
    // parses response object and call back with self.completionBlock
}

- (NSUInteger)timeoutRetryTimes
{
    return 0;
}

- (NSDictionary *)HTTPHeaderFields
{
    return nil;
}

- (NSString *)requestIdentifier
{
    return [NSString stringWithFormat:@"%@", @([self hash])];
}

#pragma mark Security policy for HTTPS

- (JCSSLPinningMode)SSLPinningMode
{
    return JCSSLPinningModeNone;
}

- (NSSet<NSData *> *)pinnedCertificates
{
    return nil;
}

- (BOOL)allowInvalidCertificates
{
    return NO;
}

- (BOOL)validatesDomainName
{
    return YES;
}

@end

#pragma mark - File upload methods

@implementation JCBaseRequest (JCBaseRequestUploadMethods)

- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName
{
    if (!uploadFilePath || !uploadName) {
        return;
    }
    if (!_uploadFilePathList) {
        _uploadFilePathList = [NSMutableArray array];
    }
    [_uploadFilePathList addObject:@[uploadFilePath, uploadName]];
}

- (void)setUploadFileData:(NSData *)uploadFileData
               uploadName:(NSString *)uploadName
           uploadFileName:(NSString *)uploadFileName
{
    if (!uploadFileData || !uploadName) {
        return;
    }
    if (!_uploadFileDataList) {
        _uploadFileDataList = [NSMutableArray array];
    }
    [_uploadFileDataList addObject:@[uploadFileData, uploadName, uploadFileName ?:@"unknown"]];
}

- (void)appendUploadFilePathBlock:(void (^)(NSString *, NSString *))uploadBlock
{
    [_uploadFilePathList enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (uploadBlock) {
            uploadBlock(obj.firstObject, obj.lastObject);
        }
    }];
}

- (void)appendUploadFileDataBlock:(void (^)(NSData *, NSString *, NSString *))uploadBlock
{
    [_uploadFileDataList enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (uploadBlock) {
            uploadBlock(obj.firstObject, obj[1], obj.lastObject);
        }
    }];
}

- (BOOL)uploadFileNeeded
{
    return (_uploadFilePathList.count > 0 || _uploadFileDataList.count > 0);
}

@end
