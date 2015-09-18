//
//  RHHttpLogKit.m
//  RHHttpDemo
//
//  Created by zhuruhong on 15/9/18.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpLogKit.h"

static BOOL httpLogEnable = YES;

@implementation RHHttpLogKit

+ (void)setLogEnable:(BOOL)enable
{
    httpLogEnable = enable;
}

+ (BOOL)isLogEnable
{
    return httpLogEnable;
}

@end
