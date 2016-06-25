//
//  JCUploadTestRequest.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/25.
//  Copyright © 2016年 Boych<https://github.com/Boych>. All rights reserved.
//

#import "JCBaseRequest.h"

@interface JCUploadTestResp : JCBaseResp

@property (nonatomic, copy) NSString<Optional> *status;

@end

@interface JCUploadTestRequest : JCBaseRequest

@end
