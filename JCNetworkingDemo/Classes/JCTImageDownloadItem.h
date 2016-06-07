//
//  JCTImageDownloadItem.h
//  JCNetworking
//
//  Created by ChenJianjun on 16/5/21.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "JCDownloadOperation.h"

extern NSString *const JCTImageDownloadGroupId;

@interface JCTImageDownloadItem : JCDownloadItem

@property (nonatomic, strong) UIImage *imageCache;

@end
