//
//  RHHttpDownloadOperation.m
//  RHToolkit
//
//  Created by zhuruhong on 15/6/29.
//  Copyright (c) 2015年 zhuruhong. All rights reserved.
//

#import "RHHttpDownloadOperation.h"
#import "NSFileManager+RHHttp.h"
#import "EXTScope.h"
#import "EGOCache.h"

@interface RHHttpDownloadOperation ()
{
    NSString *_cachePath;
    unsigned long long _offset;
    NSString *_range;
    NSURLSessionDownloadTask *_downloadTask;
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
    NSString *url = [self httpURL];
    NSDictionary *params = [self httpParameters];
    [self doHttpDownloadWithUrl:url parameters:params];
}

- (void)requestDownload:(id)request progress:(NSDictionary *)progress
{
    RHHttpLogPrint(@"[%@] requestDownload: %@", [self class], progress);
    if (_progressBlock) {
        _progressBlock(request, progress);
    }
}

- (void)doHttpDownloadWithUrl:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    RHHttpLogPrint(@"[%@] http url: %@, params: %@", [self class], URLString, parameters);
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:_range forHTTPHeaderField:@"Range"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    @weakify(self);
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        @strongify(self);
        [[EGOCache globalCache] setString:[NSString stringWithFormat:@"%lld", downloadProgress.totalUnitCount] forKey:[self keyForFileSize]];
        
        NSDictionary *progress = @{
                                   @"bytesRead":@(downloadProgress.completedUnitCount),
                                   @"totalBytesRead":@(downloadProgress.totalUnitCount)
                                   };
        [self requestDownload:self progress:progress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:_cachePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            [self requestFailure:self error:error];
            return;
        }//
        NSDictionary *result = @{ @"FilePath":filePath, @"CachePath":[self pathForCache] };
        [self requestSuccess:self response:result];
    }];
    [_downloadTask resume];
}

- (void)pause
{
    [_downloadTask suspend];
}

- (void)resume
{
    [_downloadTask resume];
}

- (void)stop
{
    [_downloadTask cancel];
}

@end
