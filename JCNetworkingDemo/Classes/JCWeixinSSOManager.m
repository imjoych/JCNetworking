//
//  JCWeixinSSOManager.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import "JCWeixinSSOManager.h"

@interface JCWeixinSSOManager ()

@property (nonatomic, strong) JCWeixinAccessTokenResp *accessTokenResp;
@property (nonatomic, strong) JCWeixinAccessTokenRequest *accessTokenRequest;
@property (nonatomic, strong) JCWeixinRefreshTokenRequest *refreshTokenRequest;
@property (nonatomic, strong) JCWeixinCheckTokenRequest *checkTokenRequest;
@property (nonatomic, strong) JCWeixinUserInfoRequest *userInfoRequest;

@end

@implementation JCWeixinSSOManager

- (void)requestOpenIdWithCode:(NSString *)code
                   completion:(void (^)(NSString *, NSError *))completion
{
    self.accessTokenRequest = [[JCWeixinAccessTokenRequest alloc] init];
    self.accessTokenRequest.appid = @"your appid";
    self.accessTokenRequest.secret = @"your secret";
    self.accessTokenRequest.code = code;
    @weakify(self);
    [self.accessTokenRequest startRequestWithDecodeClass:[JCWeixinAccessTokenResp class] completion:^(id responseObject, NSError *error) {
        @strongify(self);
        if (responseObject && !error) {
            self.accessTokenResp = responseObject;
        }
        if (completion) {
            completion(self.accessTokenResp.openid, error);
        }
    }];
}

- (void)requestUserInfoCompletion:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    [self checkAccessTokenRequest:completion];
}

#pragma mark -

- (void)checkAccessTokenRequest:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    self.checkTokenRequest = [[JCWeixinCheckTokenRequest alloc] init];
    self.checkTokenRequest.access_token = self.accessTokenResp.access_token;
    self.checkTokenRequest.openid = self.accessTokenResp.openid;
    @weakify(self);
    [self.checkTokenRequest startRequestWithDecodeClass:[JCWeixinBaseResp class] completion:^(id responseObject, NSError *error) {
        @strongify(self);
        if (responseObject && !error) {
            [self userInfoRequest:completion];
        } else {
            [self refreshTokenRequest:completion];
        }
    }];
}

- (void)userInfoRequest:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    self.userInfoRequest = [[JCWeixinUserInfoRequest alloc] init];
    self.userInfoRequest.access_token = self.accessTokenResp.access_token;
    self.userInfoRequest.openid = self.accessTokenResp.openid;
    [self.userInfoRequest startRequestWithDecodeClass:[JCWeixinUserInfoResp class] completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

- (void)refreshTokenRequest:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    self.refreshTokenRequest = [[JCWeixinRefreshTokenRequest alloc] init];
    self.refreshTokenRequest.appid = @"your appid";
    self.refreshTokenRequest.refresh_token = self.accessTokenResp.refresh_token;
    @weakify(self);
    [self.refreshTokenRequest startRequestWithDecodeClass:[JCWeixinAccessTokenResp class] completion:^(id responseObject, NSError *error) {
        @strongify(self);
        if (responseObject && !error) {
            self.accessTokenResp = responseObject;
            [self userInfoRequest:completion];
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

@end

@implementation JCWeixinBaseResp

@end

@implementation JCWeixinAccessTokenResp

@end

@implementation JCWeixinUserInfoResp

@end

@implementation JCWeixinBaseRequest

- (NSString *)baseUrl
{
    return @"https://api.weixin.qq.com/";
}

- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error
{
    // 网络请求超时或服务器错误
    if (error) {
        if (self.completionBlock) {
            self.completionBlock(nil, error);
        }
        return;
    }
    
    // 解析类不存在，直接返回数据
    Class decodeClass = [self decodeClass];
    if (!decodeClass || ![decodeClass isSubclassOfClass:[JSONModel class]]) {
        if (self.completionBlock) {
            self.completionBlock(responseObject, nil);
        }
        return;
    }
    
    NSError *respError = nil;
    JCWeixinBaseResp *resp = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        resp = [[decodeClass alloc] initWithDictionary:responseObject error:&respError];
    } else if ([responseObject isKindOfClass:[NSData class]]) {
        resp = [[decodeClass alloc] initWithData:responseObject error:&respError];
    } else if ([responseObject isKindOfClass:[NSString class]]) {
        resp = [[decodeClass alloc] initWithString:responseObject error:&respError];
    }
    // 解析数据格式错误
    if (respError || !resp) {
        if (self.completionBlock) {
            self.completionBlock(nil, respError);
        }
        return;
    }
    
    // 业务逻辑错误
    if (resp.errcode.integerValue != 0) {
        respError = [NSError errorWithDomain:@"network" code:resp.errcode.integerValue userInfo:@{NSLocalizedDescriptionKey: (resp.errmsg ?:@"")}];
        if (self.completionBlock) {
            self.completionBlock(resp, respError);
        }
        return;
    }
    
    // 正常数据
    if (self.completionBlock) {
        self.completionBlock(resp, nil);
    }
}

@end

@implementation JCWeixinAccessTokenRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.grant_type = @"authorization_code";
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"sns/oauth2/access_token";
}

@end

@implementation JCWeixinRefreshTokenRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.grant_type = @"refresh_token";
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"sns/oauth2/refresh_token";
}

@end

@implementation JCWeixinCheckTokenRequest

- (NSString *)requestUrl
{
    return @"sns/auth";
}

@end

@implementation JCWeixinUserInfoRequest

- (NSString *)requestUrl
{
    return @"sns/userinfo";
}

@end
