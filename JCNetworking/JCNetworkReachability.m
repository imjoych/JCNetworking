//
//  JCNetworkReachability.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/7.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCNetworkReachability.h"

#if !TARGET_OS_WATCH

#import <AFNetworking/AFNetworkReachabilityManager.h>

NSNotificationName const JCNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";
NSString *const JCNetworkingReachabilityNotificationStatusKey = @"AFNetworkingReachabilityNotificationStatusItem";

@implementation JCNetworkReachability

+ (NSInteger)status
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

+ (BOOL)isReachable
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

+ (BOOL)isReachableViaWWAN
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

+ (void)startMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end

#endif
