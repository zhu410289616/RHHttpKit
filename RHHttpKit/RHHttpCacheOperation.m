//
//  RHHttpCacheOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpCacheOperation.h"
#import "NSString+RHHttp.h"
#import "EGOCache.h"

@interface RHHttpCacheOperation ()
{
    NSString *_cacheKey;
    id _result;
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
    if (_shouldCache) {
        NSString *key = [self keyForCache];
        if ([[EGOCache globalCache] hasCacheForKey:key]) {
            NSData *data = [[EGOCache globalCache] dataForKey:key];
            [self requestCache:self response:data];
        }
    }
}

- (void)setCacheBlock:(void(^)(id request, id response))cacheBlock
{
    _cacheBlock = cacheBlock;
}

- (NSString *)keyForCache
{
    if (_cacheKey.length > 0) {
        return _cacheKey;
    }
    
    NSMutableString *keyMutableString = [[NSMutableString alloc] init];
    
    [keyMutableString appendString:self.urlString];
    
    if (self.parameters.allKeys.count > 0) {
        NSDictionary *params = self.parameters;
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

- (void)requestCache:(id)request response:(id)response
{
    RHHttpLogPrint(@"[%@] requestCache: %@", [self class], response);
    if (_cacheBlock) {
        _cacheBlock(request, response);
    }
}

- (void)requestSuccess:(id)request response:(id)response
{
    [super requestSuccess:request response:response];
    if (_shouldCache) {
        _result = response;
    }
}

- (void)didExecute
{
    if (_shouldCache && _result) {
        NSString *key = [self keyForCache];
        if ([_result isKindOfClass:[NSData class]]) {
            [[EGOCache globalCache] setData:_result forKey:key withTimeoutInterval:_cacheTimeout];
        } else if ([_result isKindOfClass:[NSString class]]) {
            [[EGOCache globalCache] setString:_result forKey:key withTimeoutInterval:_cacheTimeout];
        }//
    }//if
}

- (void)main
{
    [self willExecute];
    [self execute];
    [self didExecute];
}

@end
