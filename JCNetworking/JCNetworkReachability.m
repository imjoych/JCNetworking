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
#import <CoreTelephony/CTCellularData.h>

NSNotificationName const JCNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";
NSString *const JCNetworkingReachabilityNotificationStatusKey = @"AFNetworkingReachabilityNotificationStatusItem";

@implementation JCNetworkReachability

+ (NSInteger)status
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

+ (BOOL)isReachable
{
    return ([self isReachableViaWWAN] && [self isCellularDataNotRestricted]) || [self isReachableViaWiFi];
}

+ (BOOL)isReachableViaWWAN
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}

+ (BOOL)isCellularDataNotRestricted
{
    return _isCellularDataNotRestricted;
}

+ (BOOL)isReachableViaWiFi
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

+ (void)startMonitoring
{
    [self initCellularData];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark -

+ (void)initCellularData
{
    if (@available(iOS 9.0, *)) {
        [self cellularData];
    } else {
        _isCellularDataNotRestricted = YES;
    }
}

static BOOL _isCellularDataNotRestricted = NO;
static CTCellularData *_cellularData;
+ (CTCellularData *)cellularData
{
    if (!_cellularData) {
        _cellularData = [[CTCellularData alloc] init];
        _cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            switch (state) {
                case kCTCellularDataNotRestricted:
                    _isCellularDataNotRestricted = YES;
                    break;
                case kCTCellularDataRestrictedStateUnknown:
                case kCTCellularDataRestricted:
                default:
                    _isCellularDataNotRestricted = NO;
                    break;
            }
        };
    }
    return _cellularData;
}

@end

#endif
