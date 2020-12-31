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
 * The criteria by which server trust should be evaluated against the pinned SSL certificates.
 */
typedef NS_ENUM(NSUInteger, JCSSLPinningMode) {
    JCSSLPinningModeNone,
    JCSSLPinningModePublicKey,
    JCSSLPinningModeCertificate,
};

/// Block of request completion.
typedef void(^JCNetworkCompletionBlock)(id _Nullable responseObject, NSError *_Nullable error);

/// Block of file upload progress.
typedef void(^JCNetworkProgressBlock)(NSProgress *_Nonnull progress);

#endif /* JCNetworkDefines_h */
