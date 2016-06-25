# JCNetworking
A lightweight iOS networking framework based on [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [JSONModel](https://github.com/icanzilb/JSONModel).

## Features
This framework supports the development of iOS 7.0+ in ARC.

* Common request for GET/POST.
* File or data upload.

### Common Request
```objective-c
//JCAccessTokenRequest.h
@interface JCAccessTokenRequest : JCBaseRequest

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *code;

@end

//JCAccessTokenRequest.m
@implementation JCAccessTokenRequest

- (NSString *)baseUrl
{
    return @"base url";
}

- (NSString *)requestUrl
{
    return @"request url";
}

@end
```

```objective-c
- (void)startGetRequest
{
    self.accessTokenRequest = [[JCAccessTokenRequest alloc] init];
    self.accessTokenRequest.appid = @"your appid";
    self.accessTokenRequest.secret = @"your secret";
    self.accessTokenRequest.code = @"your code";
    [self.accessTokenRequest startRequestWithDecodeClass:[JCAccessTokenResp class] completion:^(id responseObject, NSError *error) {
    	//do something
    }];
}
```

### Upload
```objective-c
//JCUploadTestRequest.h
@interface JCUploadTestRequest : JCBaseRequest

@end

//JCUploadTestRequest.m
@implementation JCUploadTestRequest

- (JCRequestMethod)requestMethod
{
    return JCRequestMethodPOST;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 10;
}

- (NSString *)baseUrl
{
    return @"https://test.baseurl.com";
}

- (NSString *)requestUrl
{
    return @"requesturl/testapi";
}

@end
```

```objective-c
- (void)startUploadRequest
{
    self.uploadRequest = [[JCUploadTestRequest alloc] init];
    [self.uploadRequest setUploadFilePath:@"file path"
                               uploadName:@"file"];
    [self.uploadRequest startRequestWithDecodeClass:[JCUploadTestResp class] progress:^(NSProgress *progress) {
        //update progress
    } completion:^(id responseObject, NSError *error) {
        //do something
    }];
}
```

## CocoaPods
To integrate JCNetworking into your iOS project, specify it in your Podfile:
    
	pod 'JCNetworking'

##Contacts
If you have any questions or suggestions about the framework, please E-mail to contact me.

Author: [Boych](https://github.com/Boych)	
E-mail: ioschen@foxmail.com

## License
JCNetworking is released under the [MIT License](https://github.com/Boych/JCNetworking/blob/master/LICENSE).
