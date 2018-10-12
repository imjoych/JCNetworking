//
//  JCBaseRequest.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCNetworkDefines.h"

/**
 * HTTP base request protocol.
 */
@protocol JCBaseRequest <NSObject>

/// Start request with completion block.
- (void)startRequestWithCompletion:(JCRequestCompletionBlock)completion;

/// Start request with progress block and completion block.
- (void)startRequestWithProgress:(JCRequestProgressBlock)progress
                      completion:(JCRequestCompletionBlock)completion;

/// Stop request.
- (void)stopRequest;

/// Request completion block with response object or NSError.
- (JCRequestCompletionBlock)completionBlock;

/// Request progress block with NSProgress object.
- (JCRequestProgressBlock)progressBlock;

@end

/** 
 * HTTP base request class. 
 */
@interface JCBaseRequest : NSObject<JCBaseRequest>

/// Request method, default GET.
@property (nonatomic) JCRequestMethod requestMethod;

/// Timeout interval of request, default 60s.
@property (nonatomic) NSTimeInterval requestTimeoutInterval;

/// Request url.
@property (nonatomic, strong) NSString *requestUrl;

/// Request baseUrl.
@property (nonatomic, strong) NSString *baseUrl;

/// Request parameters.
@property (nonatomic, strong) NSDictionary *parameters;

/// HTTP header fields for request.
@property (nonatomic, strong) NSDictionary *HTTPHeaderFields;

/// Identifier of the request.
/// Duplicated requests will be removed if theirs identifiers are the same, default is hash string of the request object.
@property (nonatomic, strong) NSString *requestIdentifier;

/// Parse response object.
- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error;

/// Retry request if needed when error occurs, you can retry request several times by yourself for specific error.
- (BOOL)retryRequestIfNeeded:(NSError *)error;

#pragma mark Security policy for HTTPS

/// The criteria by which server trust should be evaluated against the pinned SSL certificates. Defaults JCSSLPinningModeNone.
@property (nonatomic) JCSSLPinningMode SSLPinningMode;

/// The certificates used to evaluate server trust according to the SSL pinning mode.
@property (nonatomic, strong) NSSet<NSData *> *pinnedCertificates;

/// Whether or not to trust servers with an invalid or expired SSL certificates. Defaults NO.
@property (nonatomic) BOOL allowInvalidCertificates;

/// Whether or not to validate the domain name in the certificate's CN field. Defaults YES.
@property (nonatomic) BOOL validatesDomainName;

@end

#pragma mark - Files upload methods

/** 
 * Files upload methods of JCBaseRequest, request with POST method.
 */
@interface JCBaseRequest (JCBaseRequestUploadMethods)

/// Set upload file path, upload operation name.
/// You can call this method repeatedly for each file path upload.
- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName;

/// Set upload file data, upload operation name, upload file name(nil is allowable).
/// You can call this method repeatedly for each file data upload.
- (void)setUploadFileData:(NSData *)uploadFileData
               uploadName:(NSString *)uploadName
           uploadFileName:(NSString *)uploadFileName;

/// Block for appending upload file path list.
- (void)appendUploadFilePathBlock:(void(^)(NSString *filePath, NSString *operationName))uploadBlock;

/// Block for appending upload file data list.
- (void)appendUploadFileDataBlock:(void(^)(NSData *fileData, NSString *operationName, NSString *fileName))uploadBlock;

/// Upload file needed or not.
- (BOOL)uploadFileNeeded;

@end
