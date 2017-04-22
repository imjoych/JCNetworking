//
//  JCNetworkDefines.h
//  JCNetworking
//
//  Created by ChenJianjun on 2016/12/5.
//  Copyright © 2016 Joych<https://github.com/imjoych>. All rights reserved.
//

#ifndef JCNetworkDefines_h
#define JCNetworkDefines_h

/**
 * Request method for JCBaseRequest.
 */
typedef NS_ENUM(NSInteger, JCRequestMethod) {
    JCRequestMethodGET,
    JCRequestMethodPOST
};

/// Block of request completion.
typedef void(^JCRequestCompletionBlock)(id responseObject, NSError *error);

/// Block of file upload progress.
typedef void(^JCRequestProgressBlock)(NSProgress *progress);

#endif /* JCNetworkDefines_h */
