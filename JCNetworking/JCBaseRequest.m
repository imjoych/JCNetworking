//
//  JCBaseRequest.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import "JCBaseRequest.h"
#import <objc/runtime.h>
#import "JCNetworkManager.h"

@implementation JCBaseResp

@end

static const char *kDecodeClassKey;

@interface JCBaseRequest () {
    NSString *_uploadFilePath;
    NSData *_uploadFileData;
    NSString *_uploadName;
    NSString *_uploadFileName;
}

@property (nonatomic, copy) JCRequestCompletionBlock completionBlock;
@property (nonatomic, copy) JCRequestProgressBlock progressBlock;

@end

@implementation JCBaseRequest

- (void)dealloc
{
    [self stopRequest];
}

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
    objc_setAssociatedObject(self, &kDecodeClassKey, decodeClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.progressBlock = progress;
    self.completionBlock = completion;
    [[JCNetworkManager sharedManager] startRequest:self];
}

- (void)stopRequest
{
    [self clearBlocks];
    [self removeDecodeClass];
    [[JCNetworkManager sharedManager] stopRequest:self];
}

- (Class)decodeClass
{
    return objc_getAssociatedObject(self, &kDecodeClassKey);
}

- (JCRequestCompletionBlock)completionBlock
{
    return _completionBlock;
}

- (JCRequestProgressBlock)progressBlock
{
    return _progressBlock;
}

#pragma mark -

- (void)clearBlocks
{
    self.completionBlock = nil;
    self.progressBlock = nil;
}

- (void)removeDecodeClass
{
    objc_removeAssociatedObjects(self);
}

@end

@implementation JCBaseRequest (JCBaseRequestExtensionMethods)

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
    // 网络请求超时或服务器错误
    if (error) {
        if (self.completionBlock) {
            self.completionBlock(nil, error);
        }
        return;
    }
    
    // 解析类不存在，直接返回数据
    Class decodeClass = [self decodeClass];
    if (!decodeClass || ![decodeClass isSubclassOfClass:[JSONModel class]]) {
        if (self.completionBlock) {
            self.completionBlock(responseObject, nil);
        }
        return;
    }
    
    NSError *respError = nil;
    JCBaseResp *resp = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        resp = [[decodeClass alloc] initWithDictionary:responseObject error:&respError];
    } else if ([responseObject isKindOfClass:[NSData class]]) {
        resp = [[decodeClass alloc] initWithData:responseObject error:&respError];
    } else if ([responseObject isKindOfClass:[NSString class]]) {
        resp = [[decodeClass alloc] initWithString:responseObject error:&respError];
    }
    // 解析数据格式错误
    if (respError || !resp) {
        if (self.completionBlock) {
            self.completionBlock(nil, respError);
        }
        return;
    }
    
    // 业务逻辑错误
    if (resp.code.integerValue != 0 && resp.code.integerValue != 200) {
        respError = [NSError errorWithDomain:@"network" code:resp.code.integerValue userInfo:@{NSLocalizedDescriptionKey: (resp.desc ?:@"")}];
        if (self.completionBlock) {
            self.completionBlock(resp, respError);
        }
        return;
    }
    
    // 正常数据
    if (self.completionBlock) {
        self.completionBlock(resp, nil);
    }
}

@end

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
