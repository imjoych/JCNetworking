//
//  JCNetworkManager.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCNetworkDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class JCNetworkConfig;

/** 
 * Network manager class. 
 */
@interface JCNetworkManager : NSObject

/// Get request.
/// @param urlString request url string
/// @param parameters request parameters
/// @param progress network progress callback
/// @param completion network completion callback
+ (nullable NSURLSessionTask *)get:(NSString *)urlString
                        parameters:(nullable NSDictionary *)parameters
                          progress:(nullable JCNetworkProgressBlock)progress
                        completion:(nullable JCNetworkCompletionBlock)completion;

/// Get request.
/// @param urlString request url string
/// @param parameters request parameters
/// @param config request config
/// @param progress network progress callback
/// @param completion network completion callback
+ (nullable NSURLSessionTask *)get:(NSString *)urlString
                        parameters:(nullable NSDictionary *)parameters
                            config:(nullable JCNetworkConfig *)config
                          progress:(nullable JCNetworkProgressBlock)progress
                        completion:(nullable JCNetworkCompletionBlock)completion;

/// Post request.
/// @param urlString request url string
/// @param parameters request parameters
/// @param progress network progress callback
/// @param completion network completion callback
+ (nullable NSURLSessionTask *)post:(NSString *)urlString
                         parameters:(nullable NSDictionary *)parameters
                           progress:(nullable JCNetworkProgressBlock)progress
                         completion:(nullable JCNetworkCompletionBlock)completion;

/// Post request.
/// @param urlString request url string
/// @param parameters request parameters
/// @param config request config
/// @param progress network progress callback
/// @param completion network completion callback
+ (nullable NSURLSessionTask *)post:(NSString *)urlString
                         parameters:(nullable NSDictionary *)parameters
                             config:(nullable JCNetworkConfig *)config
                           progress:(nullable JCNetworkProgressBlock)progress
                         completion:(nullable JCNetworkCompletionBlock)completion;

/// Upload data or file request.
/// @param urlString request url string
/// @param parameters request parameters
/// @param config request config
/// @param progress network progress callback
/// @param completion network completion callback
+ (nullable NSURLSessionTask *)upload:(NSString *)urlString
                           parameters:(nullable NSDictionary *)parameters
                               config:(JCNetworkConfig *)config
                             progress:(nullable JCNetworkProgressBlock)progress
                           completion:(nullable JCNetworkCompletionBlock)completion;

/// Cancel task
/// @param task task should be canceled
+ (void)cancelTask:(nullable NSURLSessionTask *)task;

/// Clean request config for host url.
/// @param baseUrlString base url string
+ (void)cleanRequestConfig:(nullable NSString *)baseUrlString;

@end

NS_ASSUME_NONNULL_END
