//
//  ViewController.m
//  JCNetworkingDemo
//
//  Created by ChenJianjun on 16/3/6.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "ViewController.h"
#import "JCWeixinSSOManager.h"
#import "JCNetworkConfig.h"
#import "JCNetworkManager.h"

@interface ViewController ()

@property (nonatomic, strong) JCWeixinSSOManager *ssoManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self startOpenIdRequest];
    [self startUploadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (JCWeixinSSOManager *)ssoManager
{
    if (!_ssoManager) {
        _ssoManager = [[JCWeixinSSOManager alloc] init];
    }
    return _ssoManager;
}

- (void)startOpenIdRequest
{
    @weakify(self);
    [self.ssoManager requestOpenIdWithCode:@"your code" completion:^(NSString *openId, NSError *error) {
        @strongify(self);
        NSLog(@"openId = %@，error = %@", openId, error);
        if (openId && !error) {
            [self startUserInfoRequest];
        }
    }];
}

- (void)startUserInfoRequest
{
    [self.ssoManager requestUserInfoCompletion:^(JCWeixinUserInfoResp *userInfoResp, NSError *error) {
        NSLog(@"userInfo = %@, error = %@", userInfoResp, error);
    }];
}

- (void)startUploadRequest
{
    JCNetworkConfig *config = [JCNetworkConfig new];
    [config setUploadFilePath:@"file path" uploadName:@"file"];
    [JCNetworkManager upload:@"https://test.baseurl.com/path/testapi" parameters:nil config:config progress:^(NSProgress * _Nonnull progress) {
        //update progress
    } completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        //do something
    }];
}
@end
