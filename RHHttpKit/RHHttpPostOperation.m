//
//  RHHttpPostOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpPostOperation.h"

@implementation RHHttpPostOperation

- (void)execute
{
    NSString *url = [self httpURL];
    NSDictionary *params = [self httpParameters];
    [self doHttpPostWithUrl:url parameters:params];
}

- (void)doHttpPostWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLogPrint(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (self.requestSerializer) {
        manager.requestSerializer = self.requestSerializer;
    }//if
    if (self.responseSerializer) {
        manager.responseSerializer = self.responseSerializer;
    }//if
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:self error:error];
    }];
}

@end
