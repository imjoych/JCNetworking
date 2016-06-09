//
//  JCNetworkReachabilityManager.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/7.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 网络状态发生变化通知 */
FOUNDATION_EXPORT NSString * const JCNetworkingReachabilityDidChangeNotification;

/** 网络状态管理类 */
@interface JCNetworkReachabilityManager : NSObject

/** 是否连接网络 */
+ (BOOL)isReachable;

/** 是否连接WWAN（无线广域网）*/
+ (BOOL)isReachableViaWWAN;

/** 是否连接Wi-Fi */
+ (BOOL)isReachableViaWiFi;

/** 开始监听网络变化 */
+ (void)startMonitoring;

/** 结束监听网络变化 */
+ (void)stopMonitoring;

@end
