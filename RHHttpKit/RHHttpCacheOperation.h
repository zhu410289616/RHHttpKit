//
//  RHHttpCacheOperation.h
//  RHToolkit
//
//  Created by zhuruhong on 15/6/27.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpOperation.h"

typedef void(^RHHttpCacheBlock)(id request, id response);

@interface RHHttpCacheOperation : RHHttpOperation

/* 是否开启缓存 */
@property (nonatomic, assign) BOOL shouldCache;

/* 缓存有效期, 单位秒 */
@property (nonatomic, assign) NSTimeInterval cacheTimeout;

/* 优先读取缓存, 回调block */
@property (nonatomic, copy) RHHttpCacheBlock cacheBlock;

- (NSString *)keyForCache;
- (void)requestCache:(id)request response:(id)response;

- (void)willExecute;
- (void)didExecute;

@end
