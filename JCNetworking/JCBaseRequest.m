//
//  JCBaseRequest.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCBaseRequest.h"
#import "JCNetworkManager.h"

@implementation JCModel

+ (instancetype)objWithJson:(id)json error:(NSError **)error
{
    if (!json) {
        return nil;
    }
    JCModel *model = nil;
    NSError *parseError = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        model = [[self alloc] initWithDictionary:json error:&parseError];
    } else if ([json isKindOfClass:[NSData class]]) {
        model = [[self alloc] initWithData:json error:&parseError];
    } else if ([json isKindOfClass:[NSString class]]) {
        model = [[self alloc] initWithString:json error:&parseError];
    }
    if (error && parseError) {
        *error = parseError;
        return nil;
    }
    return model;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@interface JCBaseRequest () {
    Class _decodeClass;
    JCRequestCompletionBlock _completionBlock;
    JCRequestProgressBlock _progressBlock;
    NSString *_uploadFilePath;
    NSData *_uploadFileData;
    NSString *_uploadName;
    NSString *_uploadFileName;
    NSUInteger _retryTimes;
}

@end

@implementation JCBaseRequest

- (void)dealloc
{
    [self stopRequest];
}

- (instancetype)init
{
    if (self = [super init]) {
        _retryTimes = [self timeoutRetryTimes];
    }
    return self;
}

#pragma mark - Protocol

- (void)startRequestWithDecodeClass:(Class)decodeClass
                         completion:(JCRequestCompletionBlock)completion
{
    [self startRequestWithDecodeClass:decodeClass
                             progress:nil
                           completion:completion];
}

- (void)startRequestWithDecodeClass:(Class)decodeClass
                           progress:(JCRequestProgressBlock)progress
                         completion:(JCRequestCompletionBlock)completion
{
    _decodeClass = decodeClass;
    _progressBlock = progress;
    _completionBlock = completion;
    [[JCNetworkManager sharedManager] startRequest:self];
}

- (void)stopRequest
{
    _decodeClass = nil;
    _completionBlock = nil;
    _progressBlock = nil;
    [[JCNetworkManager sharedManager] stopRequest:self];
}

- (Class)decodeClass
{
    return _decodeClass;
}

- (JCRequestCompletionBlock)completionBlock
{
    return _completionBlock;
}

- (JCRequestProgressBlock)progressBlock
{
    return _progressBlock;
}

- (void)retryRequestIfNeeded:(NSError *)error
{
    if (_retryTimes < 1
        || error.code != NSURLErrorTimedOut) {
        [self stopRequest];
        return;
    }
    
    _retryTimes--;
    [[JCNetworkManager sharedManager] startRequest:self];
}

- (NSDictionary *)filteredDictionary
{
    NSDictionary *params = [self toDictionary];
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

#pragma mark - File or data upload methods

@implementation JCBaseRequest (JCBaseRequestUploadMethods)

- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName
{
    _uploadFilePath = uploadFilePath;
    _uploadName = uploadName;
    _uploadFileName = [_uploadFilePath lastPathComponent];
}

- (void)setUploadFileData:(NSData *)uploadFileData
               uploadName:(NSString *)uploadName
           uploadFileName:(NSString *)uploadFileName
{
    _uploadFileData = uploadFileData;
    _uploadName = uploadName;
    _uploadFileName = uploadFileName;
}

- (NSString *)uploadFilePath
{
    return _uploadFilePath;
}

- (NSData *)uploadFileData
{
    return _uploadFileData;
}

- (NSString *)uploadName
{
    return _uploadName;
}

- (NSString *)uploadFileName
{
    return _uploadFileName ?:@"unknown";
}

@end
