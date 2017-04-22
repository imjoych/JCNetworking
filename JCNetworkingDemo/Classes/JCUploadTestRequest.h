//
//  JCUploadTestRequest.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/25.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCBaseRequest.h"

@interface JCUploadTestResp : JCBaseResp

@property (nonatomic, copy) NSString<Optional> *status;

@end

@interface JCUploadTestRequest : JCBaseRequest

@end
