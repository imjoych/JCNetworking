//
//  JCBaseRequest.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/** 
 * Response data for JCBaseRequest. 
 */
@interface JCBaseResp : JSONModel

@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *desc;

@end

/** 
 * Request method for JCBaseRequest. 
 */
typedef NS_ENUM(NSInteger, JCRequestMethod) {
    JCRequestMethodGET,
    JCRequestMethodPOST
};

/// Block of request completion.
typedef void(^JCRequestCompletionBlock)(id responseObject, NSError *error);

/// Block of file upload progress.
typedef void(^JCRequestProgressBlock)(NSProgress *progress);

/** 
 * HTTP base request class. 
 */
@interface JCBaseRequest : JSONModel

/** 
 * Start request with decode class and completion block. 
 */
- (void)startRequestWithDecodeClass:(Class)decodeClass
                         completion:(JCRequestCompletionBlock)completion;

/**
 * Start request with decode class, progress block and completion block. 
 */
- (void)startRequestWithDecodeClass:(Class)decodeClass
                           progress:(JCRequestProgressBlock)progress
                         completion:(JCRequestCompletionBlock)completion;

/** 
 * Stop request.
 */
- (void)stopRequest;

/// Decode class for the parse of response object.
- (Class)decodeClass;

/// Returns completion block.
- (JCRequestCompletionBlock)completionBlock;

/// Returns progress block.
- (JCRequestProgressBlock)progressBlock;

/// Retry request if timeoutRetryTimes greater than 0.
- (void)retryRequestIfNeeded:(NSError *)error;

@end

#pragma mark - Subclass implementation methods

/** 
 * Request extension methods, implementation by subclass. 
 */
@interface JCBaseRequest (JCBaseRequestExtensionMethods)

/** 
 * Request method, default GET. 
 */
- (JCRequestMethod)requestMethod;

/** 
 * Timeout interval of request, default 60s. 
 */
- (NSTimeInterval)requestTimeoutInterval;

/** 
 * Request url. 
 */
- (NSString *)requestUrl;

/** 
 * Request baseUrl. 
 */
- (NSString *)baseUrl;

/** 
 * Parse response object. 
 */
- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error;

/** 
 * Timeout retry times, the suggest retry times is not more than 3, default 0.
 */
- (NSUInteger)timeoutRetryTimes;

/** 
 * HTTP header fields for request.
 */
- (NSDictionary *)HTTPHeaderFields;

@end

#pragma mark - File or data upload methods

/** 
 * File or data upload，POST request method. 
 */
@interface JCBaseRequest (JCBaseRequestUploadMethods)

/** 
 * Set upload file path, upload operation name. 
 */
- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName;

/** 
 * Set upload file data, upload operation name, upload file name(nil is allowable). 
 */
- (void)setUploadFileData:(NSData *)uploadFileData
               uploadName:(NSString *)uploadName
           uploadFileName:(NSString *)uploadFileName;

/// Returns upload file path.
- (NSString *)uploadFilePath;

/// Returns upload file data.
- (NSData *)uploadFileData;

/// Returns upload operation name.
- (NSString *)uploadName;

/// Returns upload file name.
- (NSString *)uploadFileName;

@end
