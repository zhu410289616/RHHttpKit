//
//  RHHttpOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpOperation.h"

@implementation RHHttpOperation

- (instancetype)init
{
    if (self = [super init]) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _responseSerializer = [AFHTTPResponseSerializer serializer];
        _responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return self;
}

- (void)dealloc
{
    RHHttpLogPrint(@"[%@] dealloc...", [self class]);
}

- (NSString *)httpURL
{
    NSAssert(self.urlString.length > 0, @"urlString is nil ...");
    return _urlString;
}

- (NSDictionary *)httpParameters
{
    return _parameters;
}

- (void)execute
{
    NSString *url = [self httpURL];
    NSDictionary *params = [self httpParameters];
    [self doHttpGetWithUrl:url parameters:params];
}

- (void)doHttpGetWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLogPrint(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (_requestSerializer) {
        manager.requestSerializer = _requestSerializer;
    }//if
    if (_responseSerializer) {
        manager.responseSerializer = _responseSerializer;
    }//if
    
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:self error:error];
    }];
}

- (void)requestSuccess:(id)request response:(id)response
{
    RHHttpLogPrint(@"[%@] requestSuccess: %@", [self class], response);
    if (_successBlock) {
        _successBlock(request, response);
    }
}

- (void)requestFailure:(id)request error:(NSError *)error
{
    RHHttpLogPrint(@"[%@] requestFailure: %@", [self class], error);
    if (_failureBlock) {
        _failureBlock(request, error);
    }
}

- (void)main
{
    [self execute];
}

@end
