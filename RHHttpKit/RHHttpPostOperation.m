//
//  RHHttpPostOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpPostOperation.h"

@implementation RHHttpPostOperation

- (RHHttpMethodType)httpMethod
{
    return RHHttpMethodTypePost;
}

- (void)execute
{
    NSString *url = [self httpURL];
    NSDictionary *params = [self httpParameters];
    [self doHttpPostWithUrl:url parameters:params];
}

- (void)doHttpPostWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLog(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if ([self respondsToSelector:@selector(httpRequestSerializer)]) {
        manager.requestSerializer = [self httpRequestSerializer];
    }
    if ([self respondsToSelector:@selector(httpResponseSerializer)]) {
        manager.responseSerializer = [self httpResponseSerializer];
    }
    
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailure:self error:error];
    }];
}

@end
