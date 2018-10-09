//
//  JCModel.h
//  JCNetworkingDemo
//
//  Created by ChenJianjun on 2018/10/9.
//  Copyright © 2018 Joych<https://github.com/imjoych>. All rights reserved.
//

#import "JSONModel.h"

/**
 * Class of json data which can be translated into.
 */
@interface JCModel : JSONModel

/**
 * Json data translate into JCModel object.
 * @param json Serialization data which can be parsed.
 * @param error Errors occured when the data is not a normal json.
 * @return Json data will be parsed when it's NSDictionary / NSData / NSString and returns object of JCModel or it's subclass, other returns nil.
 */
+ (instancetype)objWithJson:(id)json error:(NSError **)error;

@end
