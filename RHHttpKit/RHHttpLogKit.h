//
//  RHHttpLogKit.h
//  RHHttpDemo
//
//  Created by zhuruhong on 15/9/18.
//  Copyright © 2015年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHHttpLogKit : NSObject

+ (void)setLogEnable:(BOOL)enable;
+ (BOOL)isLogEnable;

@end

// ---------------------------------------

#define RHHttpLogPrint(format, ...) \
    if ([RHHttpLogKit isLogEnable]) { \
        NSLog(@"%s(%d): " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
    }

// ---------------------------------------

#ifdef DEBUG
#define RHHttpLogDebug
#endif

#ifdef RHHttpLogDebug
#define RHHttpLog(format, ...) RHHttpLogPrint(format, ##__VA_ARGS__)
#else
#define RHHttpLog(format, ...)
#endif
