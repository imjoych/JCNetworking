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
    NSMutableArray<NSArray *> *_uploadFilePathList;
    NSMutableArray<NSArray *> *_uploadFileDataList;
}

@end

@implementation JCBaseRequest

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

- (NSDictionary *)filteredDictionary
{
    NSDictionary *params = _parameters;
    if (!params || params.count < 1) {
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

#pragma mark -

- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error
{
    // parses response object and call back with self.completionBlock
}

- (BOOL)retryRequestIfNeeded:(NSError *)error
{
    return NO;
}

- (NSString *)requestIdentifier
{
    return [NSString stringWithFormat:@"%@", @([self hash])];
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
