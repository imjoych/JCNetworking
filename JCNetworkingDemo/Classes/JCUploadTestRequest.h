//
//  JCUploadTestRequest.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/6/25.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCBaseRequest.h"
#import "JCModel.h"

@interface JCUploadTestResp : JCModel

@property (nonatomic, copy) NSString *status;

@end

@interface JCUploadTestRequest : JCBaseRequest

@end
