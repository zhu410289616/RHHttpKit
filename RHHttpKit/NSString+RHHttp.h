//
//  NSString+RHHttp.h
//  RHHttpDemo
//
//  Created by zhuruhong on 16/4/11.
//  Copyright © 2016年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RHHttp)

+ (NSString *)rh_stringWithMD5Encode:(NSString *)src;
- (NSString *)rh_stringWithMD5Encode;

@end
