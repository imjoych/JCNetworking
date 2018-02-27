//
//  JCBaseRequest.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "JCNetworkDefines.h"

/** 
 * Class of json data which can be translated into.
 */
@interface JCModel : JSONModel

/**
 * Json data translate into JCModel object.
 * @param json Serialization data which can be parsed.
 * @param error Errors occured when the data is not a normal json.
 * @return Json data will be parsed when it's NSDictionary / NSData / NSString and returns object of JCModel or it's subclass, other returns nil.
 */
+ (instancetype)objWithJson:(id)json error:(NSError **)error;

@end

/**
 * HTTP base request protocol.
 */
@protocol JCBaseRequest <NSObject>

/// Start request with decode class and completion block.
- (void)startRequestWithDecodeClass:(Class)decodeClass
                         completion:(JCRequestCompletionBlock)completion;

/// Start request with decode class, progress block and completion block.
- (void)startRequestWithDecodeClass:(Class)decodeClass
                           progress:(JCRequestProgressBlock)progress
                         completion:(JCRequestCompletionBlock)completion;

/// Stop request.
- (void)stopRequest;

/// Decode class for the parse of response object.
- (Class)decodeClass;

/// Returns completion block.
- (JCRequestCompletionBlock)completionBlock;

/// Returns progress block.
- (JCRequestProgressBlock)progressBlock;

/// Retry request if timeoutRetryTimes greater than 0.
- (void)retryRequestIfNeeded:(NSError *)error;

/// The values for properties are filtered which types are kind of NSNull class.
- (NSDictionary *)filteredDictionary;

@end

/** 
 * HTTP base request class. 
 */
@interface JCBaseRequest : JSONModel<JCBaseRequest>

/**
 * ----------------------------------------------------
 * Method list which should be implemented by Subclass.
 * ----------------------------------------------------
 */

/// Request method, default GET.
- (JCRequestMethod)requestMethod;

/// Timeout interval of request, default 60s.
- (NSTimeInterval)requestTimeoutInterval;

/// Request url.
- (NSString *)requestUrl;

/// Request baseUrl.
- (NSString *)baseUrl;

/// Parse response object.
- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error;

/// Timeout retry times, the suggest retry times is not more than 3, default 0.
- (NSUInteger)timeoutRetryTimes;

/// HTTP header fields for request.
- (NSDictionary *)HTTPHeaderFields;

/// Identifier of the request.
/// Duplicated requests will be removed if theirs identifiers are the same, default is hash string of the request object.
- (NSString *)requestIdentifier;

@end

#pragma mark - File or data upload methods

/** 
 * File or data upload，POST request method. 
 */
@interface JCBaseRequest (JCBaseRequestUploadMethods)

/// Set upload file path, upload operation name.
- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName;

/// Set upload file data, upload operation name, upload file name(nil is allowable).
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

#pragma mark - Security policy for HTTPS

@interface JCBaseRequest (JCBaseRequestSecurityPolicy)

/// The criteria by which server trust should be evaluated against the pinned SSL certificates. Defaults JCSSLPinningModeNone.
- (JCSSLPinningMode)SSLPinningMode;

///  The certificates used to evaluate server trust according to the SSL pinning mode.
- (NSSet<NSData *> *)pinnedCertificates;

///  Whether or not to trust servers with an invalid or expired SSL certificates. Defaults NO.
- (BOOL)allowInvalidCertificates;

///  Whether or not to validate the domain name in the certificate's CN field. Defaults YES.
- (BOOL)validatesDomainName;

@end
