//
//  JCNetworkReachabilityManager.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/7.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "JCNetworkReachabilityManager.h"
#import <AFNetworking/AFNetworking.h>

NSString * const JCNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";

@implementation JCNetworkReachabilityManager

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
