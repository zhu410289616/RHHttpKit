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
    RHHttpLog(@"[%@] dealloc...", [self class]);
}

- (void)execute
{
    NSAssert(self.urlString.length > 0, @"urlString is nil ...");
    [self doHttpGetWithUrl:self.urlString parameters:self.parameters];
}

- (void)doHttpGetWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLog(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (_requestSerializer) {
        manager.requestSerializer = _requestSerializer;
    }//if
    if (_responseSerializer) {
        manager.responseSerializer = _responseSerializer;
    }//if
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailure:self error:error];
    }];
}

- (void)requestSuccess:(id)request response:(id)response
{
    RHHttpLog(@"[%@] requestSuccess: %@", [self class], response);
    if (_successBlock) {
        _successBlock(request, response);
    }
}

- (void)requestFailure:(id)request error:(NSError *)error
{
    RHHttpLog(@"[%@] requestFailure: %@", [self class], error);
    if (_failureBlock) {
        _failureBlock(request, error);
    }
}

- (void)main
{
    [self execute];
}

@end
