//
//  JCNetworkManager.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCNetworkDefines.h"

@class JCBaseRequest;

/** 
 * Network manager class. 
 */
@interface JCNetworkManager : NSObject

/// Singleton of JCNetworkManager class.
+ (instancetype)sharedManager;

/// Start request.
- (void)startRequest:(JCBaseRequest *)request;

/// Stop request.
- (void)stopRequest:(JCBaseRequest *)request;

/// Stop all requests.
- (void)stopAllRequests;

/// Start request with decodeClass and completion block.
- (void)startRequest:(JCBaseRequest *)request
         decodeClass:(Class)decodeClass
          completion:(JCRequestCompletionBlock)completion;

/// Start request with decodeClass, progress block and completion block.
- (void)startRequest:(JCBaseRequest *)request
         decodeClass:(Class)decodeClass
            progress:(JCRequestProgressBlock)progress
          completion:(JCRequestCompletionBlock)completion;

@end
