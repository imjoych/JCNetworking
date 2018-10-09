//
//  JCModel.m
//  JCNetworkingDemo
//
//  Created by ChenJianjun on 2018/10/9.
//  Copyright © 2018 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JCModel.h"

@implementation JCModel

+ (instancetype)objWithJson:(id)json error:(NSError **)error
{
    if (!json) {
        return nil;
    }
    JCModel *model = nil;
    NSError *parseError = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        model = [[self alloc] initWithDictionary:json error:&parseError];
    } else if ([json isKindOfClass:[NSData class]]) {
        model = [[self alloc] initWithData:json error:&parseError];
    } else if ([json isKindOfClass:[NSString class]]) {
        model = [[self alloc] initWithString:json error:&parseError];
    }
    if (error && parseError) {
        *error = parseError;
        return nil;
    }
    return model;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
