//
//  RHHttpOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpOperation.h"

@implementation RHHttpOperation

- (void)dealloc
{
    RHHttpLog(@"[%@] dealloc...", [self class]);
}

- (NSString *)httpURL
{
    return DEFAULT_HTTP_URL;
}

- (NSDictionary *)httpParameters
{
    return nil;
}

- (RHHttpMethodType)httpMethod
{
    return RHHttpMethodTypeGet;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    return serializer;
}

- (AFHTTPResponseSerializer *)httpResponseSerializer
{
    AFHTTPResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    return serializer;
}

- (void)execute
{
    NSString *url = [self httpURL];
    NSDictionary *params = [self httpParameters];
    [self doHttpGetWithUrl:url parameters:params];
}

- (void)doHttpGetWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLog(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if ([self respondsToSelector:@selector(httpRequestSerializer)]) {
        manager.requestSerializer = [self httpRequestSerializer];
    }
    if ([self respondsToSelector:@selector(httpResponseSerializer)]) {
        manager.responseSerializer = [self httpResponseSerializer];
    }
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailure:self error:error];
    }];
}

- (void)requestSuccess:(id<RHHttpProtocol>)request response:(id)response
{
    RHHttpLog(@"[%@] requestSuccess: %@", [self class], response);
    if (_successBlock) {
        _successBlock(request, response);
    }
}

- (void)requestFailure:(id<RHHttpProtocol>)request error:(NSError *)error
{
    RHHttpLog(@"[%@] requestFailure: %@", [self class], error);
    if (_failureBlock) {
        _failureBlock(request, error);
    }
}

- (void)main
{
    if ([self respondsToSelector:@selector(willExecute)]) {
        [self willExecute];
    }
    
    [self execute];
    
    if ([self respondsToSelector:@selector(didExecute)]) {
        [self didExecute];
    }
}

@end
