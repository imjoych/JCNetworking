//
//  JCNetworkManager.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCBaseRequest;

/** 网络请求管理类 */
@interface JCNetworkManager : NSObject

+ (instancetype)sharedManager;

/** 开始发送网络请求 */
- (void)startRequest:(JCBaseRequest *)request;

/** 停止某个网络请求 */
- (void)stopRequest:(JCBaseRequest *)request;

/** 停止所有网络请求 */
- (void)stopAllRequests;

@end
