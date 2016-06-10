//
//  JCBaseRequest.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/** 请求响应数据 */
@interface JCBaseResp : JSONModel

@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *desc;

@end

/** 请求方法 */
typedef NS_ENUM(NSInteger, JCRequestMethod) {
    JCRequestMethodGET,
    JCRequestMethodPOST
};

/** 返回结果Block回调 */
typedef void(^JCRequestCompletionBlock)(id responseObject, NSError *error);
/** 上传进度Block回调 */
typedef void(^JCRequestProgressBlock)(NSProgress *progress);

/** HTTP请求基类 */
@interface JCBaseRequest : JSONModel

/** 请求并返回数据 */
- (void)startRequestWithDecodeClass:(Class)decodeClass
                         completion:(JCRequestCompletionBlock)completion;

/** 请求并返回实时进度数据 */
- (void)startRequestWithDecodeClass:(Class)decodeClass
                           progress:(JCRequestProgressBlock)progress
                         completion:(JCRequestCompletionBlock)completion;

/** 停止请求 */
- (void)stopRequest;

/** 解析对象类 */
- (Class)decodeClass;

/** 返回结果Block */
- (JCRequestCompletionBlock)completionBlock;

/** 进度Block */
- (JCRequestProgressBlock)progressBlock;

@end

#pragma mark -

/** 扩展方法，子类实现 */
@interface JCBaseRequest (JCBaseRequestExtensionMethods)

/** 请求方法，默认为GET */
- (JCRequestMethod)requestMethod;

/** 请求连接超时时间，默认为60秒 */
- (NSTimeInterval)requestTimeoutInterval;

/** 请求url */
- (NSString *)requestUrl;

/** 请求的baseUrl */
- (NSString *)baseUrl;

/** 解析数据 */
- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error;

@end

/** 文件数据上传，POST方法 */
@interface JCBaseRequest (JCBaseRequestUploadMethods)

/** 设置上传文件路径、上传操作名称 */
- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName;

/** 设置上传文件数据、上传操作名称、上传文件名称（可为空）*/
- (void)setUploadFileData:(NSData *)uploadFileData
               uploadName:(NSString *)uploadName
           uploadFileName:(NSString *)uploadFileName;

/** 上传文件路径 */
- (NSString *)uploadFilePath;
/** 上传文件数据 */
- (NSData *)uploadFileData;
/** 上传操作名称 */
- (NSString *)uploadName;
/** 上传文件名称 */
- (NSString *)uploadFileName;

@end
