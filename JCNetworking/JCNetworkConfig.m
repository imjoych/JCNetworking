//
//  JCNetworkConfig.m
//  JCNetworking
//
//  Created by ChenJianjun on 2020/10/30.
//  Copyright © 2020 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCNetworkConfig.h"

NSTimeInterval const JCNetworkDefaultTimeoutInterval = 15;

@interface JCNetworkConfig () {
    NSMutableArray<NSArray *> *_uploadFilePathList;
    NSMutableArray<NSArray *> *_uploadFileDataList;
}

@end

@implementation JCNetworkConfig

- (NSTimeInterval)requestTimeoutInterval
{
    return JCNetworkDefaultTimeoutInterval;
}

- (BOOL)validatesDomainName
{
    return YES;
}

#pragma mark - File upload methods

- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName
{
    if (![uploadFilePath isKindOfClass:[NSString class]]
        || ![uploadName isKindOfClass:[NSString class]]) {
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
                 mimeType:(NSString *)mimeType
{
    if (![uploadFileData isKindOfClass:[NSData class]]
        || ![uploadName isKindOfClass:[NSString class]]) {
        return;
    }
    if (![uploadFileName isKindOfClass:[NSString class]]) {
        uploadFileName = @"unknown";
    }
    if (![mimeType isKindOfClass:[NSString class]]) {
        mimeType = @"application/octet-stream";
    }
    if (!_uploadFileDataList) {
        _uploadFileDataList = [NSMutableArray array];
    }
    [_uploadFileDataList addObject:@[uploadFileData, uploadName, uploadFileName, mimeType]];
}

- (void)appendUploadFilePathBlock:(void (^)(NSString *, NSString *))uploadBlock
{
    if (_uploadFilePathList.count < 1) {
        return;
    }
    [_uploadFilePathList enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (uploadBlock) {
            uploadBlock(obj.firstObject, obj.lastObject);
        }
    }];
}

- (void)appendUploadFileDataBlock:(void (^)(NSData *, NSString *, NSString *, NSString *))uploadBlock
{
    if (_uploadFileDataList.count < 1) {
        return;
    }
    [_uploadFileDataList enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (uploadBlock) {
            uploadBlock(obj.firstObject, obj[1], obj[2], obj.lastObject);
        }
    }];
}

@end
