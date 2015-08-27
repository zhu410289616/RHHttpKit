//
//  RHHttpTest.m
//  RHHttpDemo
//
//  Created by zhuruhong on 15/8/21.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpTest.h"

@implementation RHHttpTest

- (NSString *)httpURL
{
    return _url.length > 0 ? _url : @"http://www.baidu.com";
}

- (AFHTTPResponseSerializer *)httpResponseSerializer
{
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    return serializer;
}

@end
