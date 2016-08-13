//
//  JCNetworkReachability.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/7.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import "JCNetworkReachability.h"
#import <AFNetworking/AFNetworking.h>

NSString *const JCNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";
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
