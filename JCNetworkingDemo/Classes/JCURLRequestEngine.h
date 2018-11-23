//
//  JCURLRequestEngine.h
//  JCNetworkingDemo
//
//  Created by ChenJianjun on 2018/11/23.
//  Copyright © 2018 Joych<https://github.com/imjoych>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCNetworkDefines.h"

@class JCBaseRequest;

/// URL request engine
@interface JCURLRequestEngine : NSObject

/// Start GET request.
+ (JCBaseRequest *)getWithUrl:(NSString *)url
                   completion:(JCRequestCompletionBlock)completion;

/// Start POST request.
+ (JCBaseRequest *)postWithUrl:(NSString *)url
                        params:(NSDictionary *)params
                    completion:(JCRequestCompletionBlock)completion;

/// Start upload data with POST request.
+ (JCBaseRequest *)uploadWithUrl:(NSString *)url
                          params:(NSDictionary *)params
             uploadDatasForNames:(NSDictionary *)uploadDatasForNames
                        progress:(JCRequestProgressBlock)progress
                      completion:(JCRequestCompletionBlock)completion;

@end
