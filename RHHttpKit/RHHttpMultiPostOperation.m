//
//  RHHttpMultiPostOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpMultiPostOperation.h"

@implementation RHHttpMultiPostOperation

- (NSDictionary *)httpMultipartFormDataParameters
{
    return _multipartFormDataParameters;
}

- (void)execute
{
    NSString *url = [self httpURL];
    NSDictionary *params = [self httpParameters];
    NSDictionary *multiParams = [self httpMultipartFormDataParameters];
    [self doHttpMultiPostWithUrl:url parameters:params multipartFormDataParams:multiParams];
}

- (void)doHttpMultiPostWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters multipartFormDataParams:(NSDictionary *)multipartFormDataParams
{
    RHHttpLogPrint(@"[%@] http url: %@, params: %@, multipartFormDataParams: %@", [self class], URLString, parameters, multipartFormDataParams);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (self.requestSerializer) {
        manager.requestSerializer = self.requestSerializer;
    }//if
    if (self.responseSerializer) {
        manager.responseSerializer = self.responseSerializer;
    }//if
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *multipartParamKeys = [multipartFormDataParams allKeys];
        for (id key in multipartParamKeys) {
            id value = [multipartFormDataParams objectForKey:key];
            if ([value isKindOfClass:[NSURL class]]) {
                [formData appendPartWithFileURL:value name:key error:nil];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        RHHttpLogPrint(@"uploadProgress...");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccess:self response:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:self error:error];
    }];
}

@end
