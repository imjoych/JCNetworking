//
//  JCWeixinSSOManager.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCWeixinSSOManager.h"

static NSString *const kWeixinSSOAppid = @"your appid";
static NSString *const kWeixinSSOSecret = @"your secret";

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
    [self.checkTokenRequest setParamsDictionary:@{@"appid": kWeixinSSOAppid, @"secret": kWeixinSSOSecret, @"grant_type": @"authorization_code", @"code": (code ?:@"")}];
    @weakify(self);
    [self.accessTokenRequest startRequestWithCompletion:^(id responseObject, NSError *error) {
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
    [self.checkTokenRequest setParamsDictionary:@{@"access_token": (self.accessTokenResp.access_token ?:@""), @"openid": (self.accessTokenResp.openid ?:@"")}];
    @weakify(self);
    [self.checkTokenRequest startRequestWithCompletion:^(id responseObject, NSError *error) {
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
    [self.userInfoRequest setParamsDictionary:@{@"access_token": (self.accessTokenResp.access_token ?:@""), @"openid": (self.accessTokenResp.openid ?:@"")}];
    [self.userInfoRequest startRequestWithCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

- (void)refreshTokenRequest:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    self.refreshTokenRequest = [[JCWeixinRefreshTokenRequest alloc] init];
    [self.refreshTokenRequest setParamsDictionary:@{@"appid": kWeixinSSOAppid, @"grant_type":  @"refresh_token", @"refresh_token": (self.accessTokenResp.refresh_token ?:@"")}];
    @weakify(self);
    [self.refreshTokenRequest startRequestWithCompletion:^(id responseObject, NSError *error) {
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

- (Class)decodeClass
{
    return nil;
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
    if (!decodeClass || ![decodeClass isSubclassOfClass:[JCModel class]]) {
        if (self.completionBlock) {
            self.completionBlock(responseObject, nil);
        }
        return;
    }
    
    NSError *respError = nil;
    JCWeixinBaseResp *resp = [decodeClass objWithJson:responseObject error:&respError];
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

- (NSString *)requestUrl
{
    return @"sns/oauth2/access_token";
}

- (Class)decodeClass
{
    return [JCWeixinAccessTokenResp class];
}

@end

@implementation JCWeixinRefreshTokenRequest

- (NSString *)requestUrl
{
    return @"sns/oauth2/refresh_token";
}

- (Class)decodeClass
{
    return [JCWeixinAccessTokenResp class];
}

@end

@implementation JCWeixinCheckTokenRequest

- (NSString *)requestUrl
{
    return @"sns/auth";
}

- (Class)decodeClass
{
    return [JCWeixinBaseResp class];
}

@end

@implementation JCWeixinUserInfoRequest

- (NSString *)requestUrl
{
    return @"sns/userinfo";
}

- (Class)decodeClass
{
    return [JCWeixinUserInfoResp class];
}

@end
