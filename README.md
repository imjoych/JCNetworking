# JCNetworking
A useful iOS networking framework based on [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [JSONModel](https://github.com/icanzilb/JSONModel).

## Features
This framework supports the development of iOS 7.0+ in ARC.

* Common request for GET/POST.
* File or data upload.
* File download (breakpoint downloading supported).

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
    self.accessTokenRequest.code = code;
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
- (void)startUploadRequest
{
    self.uploadRequest = [[JCUploadTestRequest alloc] init];
    [self.uploadRequest setUploadFilePath:@"file path"
                               uploadName:@"file"];
    [self.uploadRequest startRequestWithDecodeClass:[JCBaseResp class] completion:^(id responseObject, NSError *error) {
    	//do something
    }];
}
```

### Download

```objective-c
- (void)startDownloadOperation
{
	JCDownloadItem *downloadItem = [[JCDownloadItem alloc] init];
    downloadItem.downloadUrl = @"download url";
    downloadItem.downloadFilePath = @"download file path";
    JCDownloadOperation *operation = [JCDownloadOperation operationWithItem:downloadItem];
    [operation startWithProgressBlock:^(NSProgress *progress) {
        //update progress
    } completionBlock:^(NSURL *filePath, NSError *error) {
        //download operation completion, do something
    }];
}
```

## CocoaPods
To integrate JCNetworking into your iOS project, specify it in your Podfile:
    
	pod 'JCNetworking'


## License
JCNetworking is released under the [MIT License](https://github.com/Boych/JCNetworking/blob/master/LICENSE).
