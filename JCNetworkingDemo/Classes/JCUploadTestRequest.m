//
//  JCUploadTestRequest.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/25.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCUploadTestRequest.h"

@implementation JCUploadTestResp

@end

@implementation JCUploadTestRequest

- (JCRequestMethod)requestMethod
{
    return JCRequestMethodPOST;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 1;
}

- (NSString *)baseUrl
{
    return @"https://test.baseurl.com";
}

- (NSString *)requestUrl
{
    return @"requesturl/testapi";
}

- (NSUInteger)timeoutRetryTimes
{
    return 3;
}

- (BOOL)uploadFileNeeded
{
    return YES;
}

@end
