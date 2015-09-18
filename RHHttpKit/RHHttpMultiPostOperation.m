//
//  RHHttpMultiPostOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpMultiPostOperation.h"

@implementation RHHttpMultiPostOperation

- (void)execute
{
    NSAssert(self.urlString.length > 0, @"urlString is nil ...");
    [self doHttpMultiPostWithUrl:self.urlString parameters:self.parameters multipartFormDataParams:self.multipartFormDataParameters];
}

- (void)doHttpMultiPostWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters multipartFormDataParams:(NSDictionary *)multipartFormDataParams
{
    RHHttpLog(@"[%@] http url: %@, params: %@, multipartFormDataParams: %@", [self class], URLString, parameters, multipartFormDataParams);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (self.requestSerializer) {
        manager.requestSerializer = self.requestSerializer;
    }//if
    if (self.responseSerializer) {
        manager.responseSerializer = self.responseSerializer;
    }//if
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSArray *multipartParamKeys = [multipartFormDataParams allKeys];
        for (id key in multipartParamKeys) {
            id value = [multipartFormDataParams objectForKey:key];
            if ([value isKindOfClass:[NSURL class]]) {
                [formData appendPartWithFileURL:value name:key error:nil];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailure:self error:error];
    }];
}

@end
