//
//  RHHttpMultiPostOperation.h
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpOperation.h"

@interface RHHttpMultiPostOperation : RHHttpOperation

@property (nonatomic, strong) NSDictionary *multipartFormDataParameters;

- (NSDictionary *)httpMultipartFormDataParameters;

@end
