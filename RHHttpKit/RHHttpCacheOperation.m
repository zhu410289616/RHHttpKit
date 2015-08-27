//
//  RHHttpCacheOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpCacheOperation.h"
#import "NSString+MD5.h"
#import "EGOCache.h"

@interface RHHttpCacheOperation ()
{
    NSString *_cacheKey;
}

@end

@implementation RHHttpCacheOperation

- (instancetype)init
{
    if (self = [super init]) {
        _shouldCache = NO;
        _cacheTimeout = 86400;//24 * 3600 = 1 day
    }
    return self;
}

- (void)willExecute
{
    if ([self shouldReadCacheForResponse]) {
        NSString *key = [self keyForCache];
        if ([[EGOCache globalCache] hasCacheForKey:key]) {
            NSData *data = [[EGOCache globalCache] dataForKey:key];
            [self requestCache:self response:data];
        }
    }
}

- (BOOL)shouldWriteResponseToCache
{
    return _shouldCache;
}

- (BOOL)shouldReadCacheForResponse
{
    return _shouldCache;
}

- (NSString *)keyForCache
{
    if (_cacheKey.length > 0) {
        return _cacheKey;
    }
    
    NSMutableString *keyMutableString = [[NSMutableString alloc] init];
    
    [keyMutableString appendString:[self httpURL]];
    
    if ([self respondsToSelector:@selector(httpParameters)]) {
        NSDictionary *params = [self httpParameters];
        NSArray *allKeys = [params allKeys];
        NSArray *sortedAllKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        [sortedAllKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *keyValue = [NSString stringWithFormat:@"%@%@", obj, params[obj]];
            [keyMutableString appendString:keyValue];
        }];
    }
    _cacheKey = [NSString rh_stringWithMD5Encode:[keyMutableString lowercaseString]];
    return _cacheKey;
}

- (void)requestCache:(id<RHHttpProtocol>)request response:(id)response
{
    RHHttpLog(@"[%@] requestCache: %@", [self class], response);
    if (_cacheBlock) {
        _cacheBlock(request, response);
    }
}

- (void)requestSuccess:(id<RHHttpProtocol>)request response:(id)response
{
    [super requestSuccess:request response:response];
    if ([self shouldWriteResponseToCache]) {
        NSString *key = [self keyForCache];
        if ([response isKindOfClass:[NSData class]]) {
            [[EGOCache globalCache] setData:response forKey:key withTimeoutInterval:_cacheTimeout];
        } else if ([response isKindOfClass:[NSString class]]) {
            [[EGOCache globalCache] setString:response forKey:key withTimeoutInterval:_cacheTimeout];
        }
    }
}

@end
