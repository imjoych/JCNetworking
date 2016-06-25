//
//  JCUploadTestRequest.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/25.
//  Copyright © 2016年 Boych<https://github.com/Boych>. All rights reserved.
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
    return 10;
}

- (NSString *)baseUrl
{
    return @"https://test.baseurl.com";
}

- (NSString *)requestUrl
{
    return @"requesturl/testapi";
}

@end
