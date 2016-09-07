//
//  JCNetworkManager.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCBaseRequest;

/** 
 * Network manager class. 
 */
@interface JCNetworkManager : NSObject

/// Singleton of JCNetworkManager class.
+ (instancetype)sharedManager;

/// Start request which is kind of class JCBaseRequest.
- (void)startRequest:(JCBaseRequest *)request;

/// Stop request.
- (void)stopRequest:(JCBaseRequest *)request;

/** 
 * Stop all requests. 
 */
- (void)stopAllRequests;

@end
