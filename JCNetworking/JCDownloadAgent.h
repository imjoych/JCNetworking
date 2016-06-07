//
//  JCDownloadAgent.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/21.
//  Copyright © 2016年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCDownloadOperationProtocol.h"

@class JCDownloadItem;

/** 文件下载网络请求类 */
@interface JCDownloadAgent : NSObject<JCDownloadOperationProtocol>

/** 设置自动暂停并生成resumeData的最小文件大小，默认为2M */
@property (nonatomic, assign) int64_t minFileSizeForProducingResumeData;

+ (instancetype)sharedAgent;

/** 判断文件是否下载 */
- (BOOL)isFileDownloaded:(JCDownloadItem *)downloadItem;

/** 删除下载文件 */
- (void)removeDownloadFile:(JCDownloadItem *)downloadItem;

@end
