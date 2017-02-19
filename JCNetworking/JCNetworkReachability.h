//
//  JCNetworkReachability.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/7.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Notification of networking reachability did change.
 */
FOUNDATION_EXPORT NSNotificationName const JCNetworkingReachabilityDidChangeNotification;
/**
 * Status key of networking reachability. The `userInfo` dictionary contains an `NSNumber` object under the `JCNetworkingReachabilityNotificationStatusKey` key.
 */
FOUNDATION_EXPORT NSString *const JCNetworkingReachabilityNotificationStatusKey;

/** 
 * Network reachability class. 
 */
@interface JCNetworkReachability : NSObject

/** 
 * Network reachability status. 
 
 StatusUnknown          = -1,
 
 StatusNotReachable     = 0,
 
 StatusReachableViaWWAN = 1,
 
 StatusReachableViaWiFi = 2,
 */
+ (NSInteger)status;

/** 
 * Is network connected. 
 */
+ (BOOL)isReachable;

/** 
 * Is network connect to WWAN(Wireless Wide Area Network).
 */
+ (BOOL)isReachableViaWWAN;

/** 
 * Is network connect to Wi-Fi.
 */
+ (BOOL)isReachableViaWiFi;

/** 
 * Start monitoring the reachability of network. If network reachability did change, JCNetworkingReachabilityDidChangeNotification will be posted.
 */
+ (void)startMonitoring;

/** 
 * Stop monitoring the reachability of network.
 */
+ (void)stopMonitoring;

@end
