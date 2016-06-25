//
//  JCUploadTestRequest.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/25.
//  Copyright © 2016年 Boych<https://github.com/Boych>. All rights reserved.
//

#import "JCUploadTestRequest.h"

@implementation JCUploadTestRequest

- (JCRequestMethod)requestMethod
{
    return JCRequestMethodPOST;
}

- (NSString *)baseUrl
{
    return @"base url";
}

- (NSString *)requestUrl
{
    return @"request url";
}

@end
