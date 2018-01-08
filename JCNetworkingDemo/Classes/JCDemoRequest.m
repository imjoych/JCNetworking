//
//  JCDemoRequest.m
//  JCNetworkingDemo
//
//  Created by jianjun16 on 2018/1/5.
//  Copyright © 2018 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCDemoRequest.h"

@implementation JCDemoResp

@end

@implementation JCDemoRequest

- (void)parseResponseObject:(id)responseObject
                      error:(NSError *)error
{
    // request is timeout or server error occured.
    if (error) {
        if (self.completionBlock) {
            self.completionBlock(nil, error);
        }
        return;
    }
    
    // decodeClass is not exists, return json data directly.
    Class decodeClass = [self decodeClass];
    if (!decodeClass || ![decodeClass isSubclassOfClass:[JCModel class]]) {
        NSError *jsonError = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject
                                                     options:kNilOptions
                                                       error:&jsonError];
            responseObject = obj;
        }
        if (self.completionBlock) {
            self.completionBlock(responseObject, jsonError);
        }
        return;
    }
    
    NSError *respError = nil;
    JCDemoResp *resp = [decodeClass objWithJson:responseObject error:&respError];
    // parse format error.
    if (respError || !resp) {
        if (self.completionBlock) {
            self.completionBlock(nil, respError);
        }
        return;
    }
    
    // business logic error.
    if (resp.code.integerValue != 0 && resp.code.integerValue != 200) {
        respError = [NSError errorWithDomain:NSURLErrorDomain code:resp.code.integerValue userInfo:@{NSLocalizedDescriptionKey: (resp.desc ?:@"")}];
        if (self.completionBlock) {
            self.completionBlock(resp, respError);
        }
        return;
    }
    
    // normal data.
    if (self.completionBlock) {
        self.completionBlock(resp, nil);
    }
}

@end
