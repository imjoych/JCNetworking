//
//  JCDownloadUtilities.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/23.
//  Copyright © 2016年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 下载工具类 */
@interface JCDownloadUtilities : NSObject

/** 字符串MD5加密 */
+ (NSString *)md5WithString:(NSString *)string;

/** 计算文件大小 */
+ (int64_t)fileSizeWithFilePath:(NSString *)filePath;

/** 文件大小字符串 */
+ (NSString *)sizeStringWithFileSize:(int64_t)fileSize;

/** 获取文件路径
 @param fileName 文件名
 @param folderName 文件夹名称（可为空）
 */
+ (NSString *)filePathWithFileName:(NSString *)fileName
                        folderName:(NSString *)folderName;

@end
