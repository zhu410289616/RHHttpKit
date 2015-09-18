//
//  RHHttpDownloadOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/29.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpDownloadOperation.h"
#import "NSFileManager+Ext.h"
#import "EXTScope.h"
#import "EGOCache.h"

@interface RHHttpDownloadOperation ()
{
    NSString *_cachePath;
    unsigned long long _offset;
    NSString *_range;
    AFHTTPRequestOperation *_operation;
}

@end

@implementation RHHttpDownloadOperation

- (NSString *)pathForCache
{
    if (_cachePath.length > 0) {
        return _cachePath;
    }
    _cachePath = [NSString stringWithFormat:@"%@/%@", [NSFileManager rh_cacheDirectory], [self keyForCache]];
    return _cachePath;
}

- (NSString *)keyForFileSize
{
    return [NSString stringWithFormat:@"%@-size", [self keyForCache]];
}

- (void)willExecute
{
    _offset = [NSFileManager rh_fileSizeWithFilePath:[self pathForCache]];
    NSString *fileSizeKey = [self keyForFileSize];
    if ([[EGOCache globalCache] hasCacheForKey:fileSizeKey]) {
        NSString *fileSize = [[EGOCache globalCache] stringForKey:fileSizeKey];
        _range = [NSString stringWithFormat:@"bytes=%llu-%@", _offset, fileSize];
    } else {
        _range = [NSString stringWithFormat:@"bytes=%llu-", _offset];
    }
}

- (void)execute
{
    NSAssert(self.urlString.length > 0, @"urlString is nil ...");
    [self doHttpDownloadWithUrl:self.urlString parameters:self.parameters];
}

- (void)requestDownload:(id)request progress:(NSDictionary *)progress
{
    RHHttpLog(@"[%@] requestDownload: %@", [self class], progress);
    if (_progressBlock) {
        _progressBlock(request, progress);
    }
}

- (void)doHttpDownloadWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLog(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:_range forHTTPHeaderField:@"Range"];
    
    @weakify(self);
    _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    _operation.outputStream = [[NSOutputStream alloc] initToFileAtPath:_cachePath append:YES];
    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        @strongify(self);
        [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%lld", totalBytesRead] forKey:[self keyForFileSize]];
        
        NSDictionary *progress = @{
                                   @"bytesRead":@(bytesRead),
                                   @"totalBytesRead":@(totalBytesRead),
                                   @"totalBytesExpectedToRead":@(totalBytesExpectedToRead)
                                   };
        [self requestDownload:self progress:progress];
    }];
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        NSDictionary *result = @{ @"FilePath":[self pathForCache] };
        [self requestSuccess:self response:result];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [self requestFailure:self error:error];
    }];
    [_operation start];
}

- (void)pause
{
    [_operation pause];
}

- (void)resume
{
    [_operation resume];
}

- (void)stop
{
    [_operation cancel];
}

@end
