//
//  ViewController.m
//  JCNetworkingDemo
//
//  Created by ChenJianjun on 16/3/6.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "ViewController.h"
#import "JCWeixinSSOManager.h"
#import "JCUploadTestRequest.h"

@interface ViewController ()

@property (nonatomic, strong) JCWeixinSSOManager *ssoManager;
@property (nonatomic, strong) JCUploadTestRequest *uploadRequest;

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
    self.uploadRequest = [[JCUploadTestRequest alloc] init];
    [self.uploadRequest setUploadFilePath:@"file path"
                               uploadName:@"file"];
    [self.uploadRequest startRequestWithDecodeClass:[JCUploadTestResp class] progress:^(NSProgress *progress) {
        //update progress
    } completion:^(id responseObject, NSError *error) {
        //do something
    }];
}
@end
