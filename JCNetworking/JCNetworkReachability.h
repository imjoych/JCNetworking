//
//  JCNetworkReachability.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/7.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Notification of networking reachability did change. */
FOUNDATION_EXPORT NSString *const JCNetworkingReachabilityDidChangeNotification;

/** Network reachability class. */
@interface JCNetworkReachability : NSObject

/** Is network connected. */
+ (BOOL)isReachable;

/** Is network connect to WWAN（Wireless Wide Area Network）*/
+ (BOOL)isReachableViaWWAN;

/** Is network connect to Wi-Fi */
+ (BOOL)isReachableViaWiFi;

/** start monitoring the reachability of network. If network reachability did change, JCNetworkingReachabilityDidChangeNotification will be posted. */
+ (void)startMonitoring;

/** stop monitoring the reachability of network. */
+ (void)stopMonitoring;

@end
