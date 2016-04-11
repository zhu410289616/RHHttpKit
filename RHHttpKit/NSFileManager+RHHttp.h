//
//  NSFileManager+RHHttp.h
//  RHHttpDemo
//
//  Created by zhuruhong on 16/4/11.
//  Copyright © 2016年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (RHHttp)

+ (NSString *)rh_pathWithFilePath:(NSString *)filepath;
+ (NSString *)rh_directoryInUserDomain:(NSSearchPathDirectory)directory;
+ (NSString *)rh_cacheDirectory;
+ (NSString *)rh_documentDirectory;
+ (unsigned long long)rh_fileSizeWithFilePath:(NSString *)filepath;
+ (unsigned long long)rh_fileSizeWithDirectory:(NSString *)directory;

@end
