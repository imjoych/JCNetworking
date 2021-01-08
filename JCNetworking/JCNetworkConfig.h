//
//  JCNetworkConfig.h
//  JCNetworking
//
//  Created by ChenJianjun on 2020/10/30.
//  Copyright © 2020 Joych<https://github.com/imjoych>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCNetworkDefines.h"

FOUNDATION_EXPORT NSTimeInterval const JCNetworkDefaultTimeoutInterval;

@interface JCNetworkConfig : NSObject

/// Timeout interval of request, default 15s.
@property (nonatomic) NSTimeInterval requestTimeoutInterval;

/// HTTP header fields for request.
@property (nonatomic, strong) NSDictionary *HTTPHeaderFields;

#pragma mark - Security policy for HTTPS

/// The criteria by which server trust should be evaluated against the pinned SSL certificates. Defaults JCSSLPinningModeNone.
@property (nonatomic) JCSSLPinningMode SSLPinningMode;

/// The certificates used to evaluate server trust according to the SSL pinning mode.
@property (nonatomic, strong) NSSet<NSData *> *pinnedCertificates;

/// Whether or not to trust servers with an invalid or expired SSL certificates. Defaults NO.
@property (nonatomic) BOOL allowInvalidCertificates;

/// Whether or not to validate the domain name in the certificate's CN field. Defaults YES.
@property (nonatomic) BOOL validatesDomainName;

#pragma mark - Files upload methods

/// Set upload file path, upload operation name.
/// You can call this method repeatedly for each file path upload.
- (void)setUploadFilePath:(NSString *)uploadFilePath
               uploadName:(NSString *)uploadName;

/// Set upload file data, upload operation name, upload file name(nil is available), mime type.
/// You can call this method repeatedly for each file data upload.
- (void)setUploadFileData:(NSData *)uploadFileData
               uploadName:(NSString *)uploadName
           uploadFileName:(NSString *)uploadFileName
                 mimeType:(NSString *)mimeType;

/// Block for appending upload file path list.
- (void)appendUploadFilePathBlock:(void(^)(NSString *filePath, NSString *operationName))uploadBlock;

/// Block for appending upload file data list.
- (void)appendUploadFileDataBlock:(void(^)(NSData *fileData, NSString *operationName, NSString *fileName, NSString *mimeType))uploadBlock;

@end
