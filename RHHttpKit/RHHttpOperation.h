//
//  RHHttpOperation.h
//  RHToolkit
//
//  Created by zhuruhong on 15/6/25.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHHttpProtocol.h"

typedef void(^RHHttpSuccessBlock)(id<RHHttpProtocol> request, id response);
typedef void(^RHHttpFailureBlock)(id<RHHttpProtocol> request, NSError *error);

@interface RHHttpOperation : NSOperation <RHHttpProtocol>

@property (nonatomic, copy) RHHttpSuccessBlock successBlock;
@property (nonatomic, copy) RHHttpFailureBlock failureBlock;

@end
