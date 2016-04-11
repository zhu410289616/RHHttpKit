//
//  NSFileManager+RHHttp.m
//  RHHttpDemo
//
//  Created by zhuruhong on 16/4/11.
//  Copyright © 2016年 zhuruhong. All rights reserved.
//

#import "NSFileManager+RHHttp.h"

@implementation NSFileManager (RHHttp)

+ (NSString *)rh_pathWithFilePath:(NSString *)filepath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filepath isDirectory:NULL]) {
        return filepath;
    }
    [fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    return filepath;
}

+ (NSString *)rh_directoryInUserDomain:(NSSearchPathDirectory)directory
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *dir = [directories[0] stringByAppendingPathComponent:[NSProcessInfo processInfo].processName];
    return [self rh_pathWithFilePath:dir];
}

+ (NSString *)rh_cacheDirectory
{
    return [self rh_directoryInUserDomain:NSCachesDirectory];
}

+ (NSString *)rh_documentDirectory
{
    return [self rh_directoryInUserDomain:NSDocumentDirectory];
}

+ (unsigned long long)rh_fileSizeWithFilePath:(NSString *)filepath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filepath isDirectory:NULL]) {
        NSDictionary *fileAttributes = [fm attributesOfItemAtPath:filepath error:nil];
        return [fileAttributes fileSize];
    }
    return 0;
}

+ (unsigned long long)rh_fileSizeWithDirectory:(NSString *)directory
{
    return 0;
}

@end
