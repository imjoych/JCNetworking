//
//  JCWeixinSSOManager.m
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCWeixinSSOManager.h"
#import "JCNetworkManager.h"

static NSString *const kWeixinSSOAppid = @"your appid";
static NSString *const kWeixinSSOSecret = @"your secret";

@interface JCWeixinSSOManager ()

@property (nonatomic, strong) JCWeixinAccessTokenResp *accessTokenResp;

@end

@implementation JCWeixinSSOManager

- (void)requestOpenIdWithCode:(NSString *)code
                   completion:(void (^)(NSString *, NSError *))completion
{
    @weakify(self);
    [self requestWithPath:@"sns/oauth2/access_token" parameters:@{@"appid": kWeixinSSOAppid, @"secret": kWeixinSSOSecret, @"grant_type": @"authorization_code", @"code": (code ?:[NSNull null])} decodeClass:[JCWeixinAccessTokenResp class] completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        @strongify(self);
        if (responseObject && !responseObject) {
            self.accessTokenResp = responseObject;
        }
        if (completion) {
            completion(self.accessTokenResp.openid, error);
        }
    }];
}

- (NSString *)urlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"https://api.weixin.qq.com/%@", path];
}

- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error
                decodeClass:(Class)decodeClass
                 completion:(nullable JCNetworkCompletionBlock)completionBlock
{
    // 网络请求超时或服务器错误
    if (error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    // 解析类不存在，直接返回数据
    if (!decodeClass || ![decodeClass isSubclassOfClass:[JCModel class]]) {
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
        return;
    }
    
    NSError *respError = nil;
    JCWeixinBaseResp *resp = [decodeClass objWithJson:responseObject error:&respError];
    // 解析数据格式错误
    if (respError || !resp) {
        if (completionBlock) {
            completionBlock(nil, respError);
        }
        return;
    }
    
    // 业务逻辑错误
    if (resp.errcode.integerValue != 0) {
        respError = [NSError errorWithDomain:@"network" code:resp.errcode.integerValue userInfo:@{NSLocalizedDescriptionKey: (resp.errmsg ?:@"")}];
        if (completionBlock) {
            completionBlock(resp, respError);
        }
        return;
    }
    
    // 正常数据
    if (completionBlock) {
        completionBlock(resp, nil);
    }
}

- (void)requestUserInfoCompletion:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    [self checkAccessTokenRequest:completion];
}

#pragma mark -

- (void)requestWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
            decodeClass:(Class)decodeClass
             completion:(JCNetworkCompletionBlock)completion
{
    [JCNetworkManager get:[self urlWithPath:path] parameters:parameters progress:nil completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        [self parseResponseObject:responseObject error:error decodeClass:decodeClass completion:^(id  _Nullable resp, NSError * _Nullable err) {
            if (completion) {
                completion(resp, err);
            }
        }];
    }];
}

/** 检验授权凭证（access_token）是否有效 */
- (void)checkAccessTokenRequest:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    @weakify(self);
    [self requestWithPath:@"sns/auth" parameters:@{@"access_token": (self.accessTokenResp.access_token ?:@""), @"openid": (self.accessTokenResp.openid ?:@"")} decodeClass:[JCWeixinBaseResp class] completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        @strongify(self);
        if (responseObject && !error) {
            [self userInfoRequest:completion];
        } else {
            [self refreshTokenRequest:completion];
        }
    }];
}

/** 获取用户个人信息 */
- (void)userInfoRequest:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    [self requestWithPath:@"sns/userinfo" parameters:@{@"access_token": (self.accessTokenResp.access_token ?:@""), @"openid": (self.accessTokenResp.openid ?:@"")} decodeClass:[JCWeixinUserInfoResp class] completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

/** 使用refresh_token刷新access_token */
- (void)refreshTokenRequest:(void (^)(JCWeixinUserInfoResp *, NSError *))completion
{
    @weakify(self);
    [self requestWithPath:@"sns/oauth2/refresh_token" parameters:@{@"appid": kWeixinSSOAppid, @"grant_type":  @"refresh_token", @"refresh_token": (self.accessTokenResp.refresh_token ?:@"")} decodeClass:[JCWeixinAccessTokenResp class] completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
