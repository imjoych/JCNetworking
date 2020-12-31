//
//  JCURLRequestEngine.m
//  JCNetworkingDemo
//
//  Created by ChenJianjun on 2018/11/23.
//  Copyright © 2018 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCURLRequestEngine.h"
#import "JCBaseRequest.h"

@implementation JCURLRequestEngine

+ (JCBaseRequest *)getWithUrl:(NSString *)url completion:(JCNetworkCompletionBlock)completion
{
    return [self requestWithUrl:url params:nil method:JCRequestMethodGET completion:completion];
}

+ (JCBaseRequest *)postWithUrl:(NSString *)url params:(NSDictionary *)params completion:(JCNetworkCompletionBlock)completion
{
    return [self requestWithUrl:url params:params method:JCRequestMethodPOST completion:completion];
}

+ (JCBaseRequest *)uploadWithUrl:(NSString *)url params:(NSDictionary *)params uploadDatasForNames:(NSDictionary *)uploadDatasForNames progress:(JCNetworkProgressBlock)progress completion:(JCNetworkCompletionBlock)completion
{
    return [self requestWithUrl:url params:params method:JCRequestMethodPOST uploadDatasForNames:uploadDatasForNames progress:progress completion:completion];
}

#pragma mark -

+ (JCBaseRequest *)requestWithUrl:(NSString *)url params:(NSDictionary *)params method:(JCRequestMethod)method completion:(JCNetworkCompletionBlock)completion
{
    return [self requestWithUrl:url params:params method:method uploadDatasForNames:nil progress:nil completion:completion];
}

+ (JCBaseRequest *)requestWithUrl:(NSString *)url params:(NSDictionary *)params method:(JCRequestMethod)method uploadDatasForNames:(NSDictionary *)uploadDatasForNames progress:(JCNetworkProgressBlock)progress completion:(JCNetworkCompletionBlock)completion
{
    if (![url isKindOfClass:[NSString class]] || url.length < 1) {
        if (completion) {
            completion(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:@"invalid url"}]);
        }
        return nil;
    }
    JCBaseRequest *request = [self requestWithURL:[NSURL URLWithString:url] params:params method:method];
    if ([uploadDatasForNames isKindOfClass:[NSDictionary class]]) {
        for (NSString *name in uploadDatasForNames.allKeys) {
            [request setUploadFileData:uploadDatasForNames[name] uploadName:name uploadFileName:@"file"];
        }
    }
    [request startRequestWithProgress:progress completion:^(id responseObject, NSError *error) {
        if (responseObject && !error) {
            if (completion) {
                completion(responseObject, nil);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
    return request;
}

+ (JCBaseRequest *)requestWithURL:(NSURL *)URL params:(NSDictionary *)params method:(JCRequestMethod)method
{
    if (![URL isKindOfClass:[NSURL class]] || URL.host.length < 1) {
        return nil;
    }
    NSString *baseUrl = [NSString stringWithFormat:@"%@://%@", URL.scheme, URL.host];
    NSRange range = [URL.absoluteString rangeOfString:baseUrl];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString *requestUrl = @"";
    if (URL.absoluteString.length > range.length) {
        requestUrl = [URL.absoluteString substringFromIndex:range.length];
    }
    if ([requestUrl hasPrefix:@"/"]) { // Remove slash of path
        requestUrl = [requestUrl substringFromIndex:1];
    }
    JCBaseRequest *request = [JCBaseRequest new];
    request.baseUrl = baseUrl;
    request.requestUrl = requestUrl;
    request.requestMethod = method;
    request.parameters = params;
    return request;
}

@end
