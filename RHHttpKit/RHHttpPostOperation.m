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
    NSAssert(self.urlString.length > 0, @"urlString is nil ...");
    [self doHttpPostWithUrl:self.urlString parameters:self.parameters];
}

- (void)doHttpPostWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLog(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (self.requestSerializer) {
        manager.requestSerializer = self.requestSerializer;
    }//if
    if (self.responseSerializer) {
        manager.responseSerializer = self.responseSerializer;
    }//if
    
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailure:self error:error];
    }];
}

@end
