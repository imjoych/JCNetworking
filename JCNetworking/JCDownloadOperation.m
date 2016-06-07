//
//  JCDownloadOperation.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/21.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "JCDownloadOperation.h"
#import "JCDownloadQueue.h"
#import "JCDownloadUtilities.h"

@implementation JCDownloadItem

- (NSString *)downloadId
{
    if (_downloadId.length < 1) {
        _downloadId = [JCDownloadUtilities md5WithString:self.downloadUrl];
    }
    return _downloadId;
}

@end

NSString *const JCDownloadProgressNotification = @"kJCDownloadProgressNotification";
NSString *const JCDownloadCompletionNotification = @"kJCDownloadCompletionNotification";
NSString *const JCDownloadIdKey = @"kJCDownloadIdKey";
NSString *const JCDownloadProgressKey = @"kJCDownloadProgressKey";
NSString *const JCDownloadCompletionFilePathKey = @"kJCDownloadCompletionFilePathKey";
NSString *const JCDownloadCompletionErrorKey = @"kJCDownloadCompletionErrorKey";

@interface JCDownloadOperation ()

@property (nonatomic, copy) JCDownloadProgressBlock progressBlock;
@property (nonatomic, copy) JCDownloadCompletionBlock completionBlock;

@end

@implementation JCDownloadOperation

- (void)dealloc
{
    [self clearBlocks];
}

- (void)startDownload
{
    [[JCDownloadQueue sharedQueue] startDownload:self];
}

- (void)startWithProgressBlock:(JCDownloadProgressBlock)progressBlock
               completionBlock:(JCDownloadCompletionBlock)completionBlock
{
    [self resetProgressBlock:progressBlock completionBlock:completionBlock];
    [self startDownload];
}

- (void)resetProgressBlock:(JCDownloadProgressBlock)progressBlock
           completionBlock:(JCDownloadCompletionBlock)completionBlock
{
    self.progressBlock = progressBlock;
    self.completionBlock = completionBlock;
}

- (void)pauseDownload
{
    [[JCDownloadQueue sharedQueue] pauseDownload:self];
}

- (void)finishDownload
{
    [[JCDownloadQueue sharedQueue] finishDownload:self];
}

- (void)removeDownload
{
    [self clearBlocks];
    [[JCDownloadQueue sharedQueue] removeDownload:self];
}

#pragma mark -

- (void)clearBlocks
{
    self.completionBlock = nil;
    self.progressBlock = nil;
}

@end
