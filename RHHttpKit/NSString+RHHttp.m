//
//  NSString+RHHttp.m
//  RHHttpDemo
//
//  Created by zhuruhong on 16/4/11.
//  Copyright © 2016年 zhuruhong. All rights reserved.
//

#import "NSString+RHHttp.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RHHttp)

+ (NSString *)rh_stringWithMD5Encode:(NSString *)src
{
    if(src && [src isKindOfClass:[NSString class]]){
        const char *cStr = [src UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
        
        return [NSString stringWithFormat:
                @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    return src;
}

- (NSString *)rh_stringWithMD5Encode
{
    return [NSString rh_stringWithMD5Encode:self];
}

@end
