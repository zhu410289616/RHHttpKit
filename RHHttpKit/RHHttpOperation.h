//
//  RHHttpOperation.h
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "RHHttpLogKit.h"

typedef void(^RHHttpSuccessBlock)(id request, id response);
typedef void(^RHHttpFailureBlock)(id request, NSError *error);

@interface RHHttpOperation : NSOperation

@property (nonatomic, copy) RHHttpSuccessBlock successBlock;
@property (nonatomic, copy) RHHttpFailureBlock failureBlock;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;

- (void)execute;

- (void)requestSuccess:(id)request response:(id)response;
- (void)requestFailure:(id)request error:(NSError *)error;

@end
