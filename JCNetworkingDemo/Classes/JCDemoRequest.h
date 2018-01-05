//
//  JCDemoRequest.h
//  JCNetworkingDemo
//
//  Created by jianjun16 on 2018/1/5.
//  Copyright © 2018年 Boych<https://github.com/Boych>. All rights reserved.
//

#import "JCBaseRequest.h"

@interface JCDemoResp : JCModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *desc;

@end

@interface JCDemoRequest : JCBaseRequest

@end
