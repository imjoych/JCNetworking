//
//  ViewController.m
//  JCNetworkingDemo
//
//  Created by ChenJianjun on 16/3/6.
//  Copyright © 2016 Boych<https://github.com/Boych>. All rights reserved.
//

#import "ViewController.h"
#import "JCNetworking.h"
#import "JCWeixinSSOManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testHTTPRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)testHTTPRequest
{
    [[JCWeixinSSOManager sharedManager] requestOpenIdWithCode:@"your code" completion:^(NSString *openId, NSError *error) {
        NSLog(@"openId = %@，error = %@", openId, error);
        if (openId && !error) {
            [[JCWeixinSSOManager sharedManager] requestUserInfoCompletion:^(JCWeixinUserInfoResp *userInfoResp, NSError *error) {
                NSLog(@"userInfo = %@, error = %@", userInfoResp, error);
            }];
        }
    }];
}

@end
