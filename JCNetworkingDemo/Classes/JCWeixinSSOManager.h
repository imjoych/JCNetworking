//
//  JCWeixinSSOManager.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCBaseRequest.h"

@class JCWeixinUserInfoResp;
@interface JCWeixinSSOManager : NSObject

- (void)requestOpenIdWithCode:(NSString *)code
                   completion:(void(^)(NSString *openId, NSError *error))completion;

- (void)requestUserInfoCompletion:(void(^)(JCWeixinUserInfoResp *userInfoResp, NSError *error))completion;

@end

/** 响应数据 */
@interface JCWeixinBaseResp : JSONModel

@property (nonatomic, copy) NSString *errcode;
@property (nonatomic, copy) NSString *errmsg;

@end

@interface JCWeixinAccessTokenResp : JCWeixinBaseResp

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *scope;

@end

@interface JCWeixinUserInfoResp : JCWeixinBaseResp

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSArray *privilege;
@property (nonatomic, copy) NSString *unionid;

@end

@interface JCWeixinBaseRequest : JCBaseRequest

@end

/** 通过code获取access_token */
@interface JCWeixinAccessTokenRequest : JCWeixinBaseRequest

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *grant_type;

@end

/** 使用refresh_token刷新access_token */
@interface JCWeixinRefreshTokenRequest : JCWeixinBaseRequest

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *grant_type;
@property (nonatomic, strong) NSString *refresh_token;

@end

/** 检验授权凭证（access_token）是否有效 */
@interface JCWeixinCheckTokenRequest : JCWeixinBaseRequest

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *openid;

@end

/** 获取用户个人信息 */
@interface JCWeixinUserInfoRequest : JCWeixinBaseRequest

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *openid;

@end
