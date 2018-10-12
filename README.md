# JCNetworking
A lightweight iOS networking framework based on [AFNetworking](https://github.com/AFNetworking/AFNetworking).

## Features
This framework supports the development of iOS 8.0+ in ARC.

* Common request for GET/POST.
* HTTPS request supported.
* File or data upload.

### Common Request
```objective-c
//JCAccessTokenRequest.h
@interface JCAccessTokenRequest : JCBaseRequest

- (Class)decodeClass;

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

- (Class)decodeClass
{
    return [JCAccessTokenResp class];
}

@end
```

```objective-c
- (void)startGetRequest
{
    self.accessTokenRequest = [[JCAccessTokenRequest alloc] init];
    self.accessTokenRequest.parameters = @{@"appid":@"your appid", @"secret":@"your secret", @"code":@"your code"};
    [self.accessTokenRequest startRequestWithCompletion:^(id responseObject, NSError *error) {
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
    [self.uploadRequest startRequestWithProgress:^(NSProgress *progress) {
        //update progress
    } completion:^(id responseObject, NSError *error) {
        //do something
    }];
}
```

## CocoaPods
To integrate JCNetworking into your iOS project, specify it in your Podfile:
    
	pod 'JCNetworking'

## Contacts
If you have any questions or suggestions about the framework, please E-mail to contact me.

Author: [Joych](https://github.com/imjoych)	
E-mail: imjoych@gmail.com

## License
JCNetworking is released under the [MIT License](https://github.com/imjoych/JCNetworking/blob/master/LICENSE).
