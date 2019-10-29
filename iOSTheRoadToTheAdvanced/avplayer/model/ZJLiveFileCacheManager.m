//
//  ZJLiveFileCacheManager.m
//  aizongjie
//
//  Created by huangbaoxian on 2019/10/10.
//  Copyright © 2019 wennzg. All rights reserved.
//

#import "ZJLiveFileCacheManager.h"
#import "AFNetworking.h"

@interface ZJLiveFileCacheManager ()

/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
/* AFURLSessionManager */
@property (nonatomic, strong) AFURLSessionManager *manager;

@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, strong) NSMutableDictionary *downLoadTaskDict;

@end

static ZJLiveFileCacheManager *_manager = nil;

@implementation ZJLiveFileCacheManager
- (instancetype)init {
    if (self = [super init]) {
        _downLoadTaskDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


+ (ZJLiveFileCacheManager *)getInstance {
    @synchronized (self) {
        if (!_manager) {
            _manager = [[ZJLiveFileCacheManager alloc] init];
        }
        return _manager;
    }
}
- (FileDownLoadStatus)getFileStatus:(NSString *)FileUrl{
    if ([self isDownLoading:FileUrl]) {
        return FileDownLoadDownLoading;
    }else if ([self isFileExist:FileUrl]){
        NSString *path = [self getFilePath:FileUrl];
        NSInteger totalLength = [self fileTotalLengthForPath:FileUrl];
        NSInteger downloadLength = [self fileLengthForPath:path];
        if (totalLength == downloadLength) {
            return FileDownLoadStatusComplete;
        }else{
            return FileDownLoadStatusPause;
        }
    }else{
        return FileDownLoadStatusNotExist;
    }
}
- (void)downloadWithUrl:(NSString *)url delegate:(id<ZJLiveFileCacheManagerDelegate>)delegate{
    FileDownLoadStatus status = [self getFileStatus:url];
    switch (status) {
        case FileDownLoadDownLoading:{
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.downLoadTaskDict objectForKey:url]];
            if (delegate) {
                [array addObject:delegate];
            }
            [self.downLoadTaskDict setValue:array forKey:url];
        }
            break;
        case FileDownLoadStatusComplete:{
            if (delegate) {
                [delegate downloadComplete:url];
            }
        }
        case FileDownLoadStatusPause:
        case FileDownLoadStatusNotExist:{
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.downLoadTaskDict objectForKey:url]];
            if (delegate) {
                [array addObject:delegate];
            }
            [self.downLoadTaskDict setValue:array forKey:url];
            if (self.isDownloading) {//正在下载
                
            }else{
                self.currentUrl = url;
                [self startDownLoad];
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)isDownLoading:(NSString *)url {
    NSArray *keyArray = [self.downLoadTaskDict allKeys];
    if ([keyArray containsObject:url]) {
        return YES;
    }
    return NO;
}

/**
 * manager的懒加载
 */
- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 1. 创建会话管理者
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}


- (void)startDownLoad {
    if (self.isDownloading) {
        return;
    }
    NSString *path = [self getFilePath:self.currentUrl];
    
    //    NSLog(@"start Path: %@",path);
    NSInteger currentLength = [self fileLengthForPath:path];
    if (currentLength > 0) {  // [继续下载]
        self.currentLength = currentLength;
    }
    self.isDownloading = YES;
    [self creatSesstionTask];
    if (self.downloadTask) {
        [self.downloadTask resume];
    }else {
        self.isDownloading = NO;
    }
    
}

- (void)stopDownLoad {
    [_downloadTask suspend];
    _downloadTask = nil;
    self.isDownloading = NO;
}

- (void)creatSesstionTask {
    
    NSURL *url = [NSURL URLWithString:self.currentUrl];
    
    // 2.创建request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置HTTP请求头中的Range
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    __weak typeof(self) weakSelf = self;
    _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"下载完成");
        // 清空长度
        weakSelf.currentLength = 0;
        weakSelf.fileLength = 0;
        
        // 关闭fileHandle
        [weakSelf.fileHandle closeFile];
        weakSelf.fileHandle = nil;
        weakSelf.isDownloading = NO;
        
        NSArray *delegateArray = [weakSelf.downLoadTaskDict objectForKey:weakSelf.currentUrl];
        for (id<ZJLiveFileCacheManagerDelegate> delegate in delegateArray) {
            if (delegate && [delegate respondsToSelector:@selector(downloadComplete:)]) {
                [delegate downloadComplete:weakSelf.currentUrl];
            }
        }
        if (weakSelf.currentUrl) {
            [weakSelf.downLoadTaskDict removeObjectForKey:weakSelf.currentUrl];
            weakSelf.currentUrl = nil;
        }
        
        for (NSString *urlKey in [weakSelf.downLoadTaskDict allKeys]) {
            [weakSelf stopDownLoad];
            weakSelf.currentUrl = urlKey;
            [weakSelf startDownLoad];
            break;
        }
        
    }];
    
    [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        //        NSLog(@"NSURLSessionResponseDisposition");
        
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        weakSelf.fileLength = response.expectedContentLength + weakSelf.currentLength;
        //将文件长度保存，用于比较是否完成下载
        [weakSelf setCurrentTotalFileLength];
        // 沙盒文件路径
        NSString *path = [weakSelf getFilePath:weakSelf.currentUrl];
        
        //        NSLog(@"File downloaded to: %@",path);
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:path]) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [manager createFileAtPath:path contents:nil attributes:nil];
        }
        // 创建文件句柄
        weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        //        NSLog(@"setDataTaskDidReceiveDataBlock");
        
        
        // 指定数据的写入位置 -- 文件内容的最后面
        [weakSelf.fileHandle seekToEndOfFile];
        
        // 向沙盒写入数据
        [weakSelf.fileHandle writeData:data];
        
        // 拼接文件总长度
        weakSelf.currentLength += data.length;
        
        // 获取主线程，不然无法正确显示进度。
        if (weakSelf.fileLength == 0) {
            weakSelf.fileLength = 100;
        }
        NSInteger progre =  100 * ((CGFloat)weakSelf.currentLength/(CGFloat)weakSelf.fileLength);
        
        NSLog(@"current: %d  totle %d %d", weakSelf.currentLength,weakSelf.fileLength, progre );
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            NSArray *delegateArray = [weakSelf.downLoadTaskDict objectForKey:weakSelf.currentUrl];
            if (delegateArray.count) {
                for (id<ZJLiveFileCacheManagerDelegate> delegate in delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(downloadProgress:url:)]) {
                        [delegate downloadProgress:progre url:weakSelf.currentUrl];
                    }
                }
            }
        }];
    }];
}


/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}
- (void)setCurrentTotalFileLength{
    //    if (![[NSUserDefaults standardUserDefaults] integerForKey:self.currentUrl]) {
    NSString *key = [self.currentUrl stringByDeletingPathExtension];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.fileLength) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    }
}
- (NSInteger)fileTotalLengthForPath:(NSString *)path {
    NSString *key = [path stringByDeletingPathExtension];
    NSNumber *length = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (length) {
        return length.integerValue;
    }else{
        return -1;
    }
}




- (BOOL)isFileExist:(NSString *)fileUrl {
    NSString *path = [self getFilePath:fileUrl];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}
- (NSString *)getFilePath:(NSString *)fileUrl {
    NSString * fileName = [self getFileName:fileUrl];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"fileCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}
- (NSString *)getFileName:(NSString *)url {
    NSString * extension = [url pathExtension];
    NSString * fileName = [NSString stringWithFormat:@"%@.%@",[url md5],extension];
    
    return fileName;
}

- (BOOL)removeFileWith:(NSString *)url {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSString *fileName = [self getFileName:url];
    
    NSString *path = [self getFilePath:url];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        BOOL isRemove = [fileManager removeItemAtPath:path error:&error];
        if (error) {
            return NO;
        }
        return isRemove;
    }
    return NO;
}

- (void)cleanAllCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"fileCache"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
        NSString *fileName;
        while (fileName= [dirEnum nextObject]) {
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:nil];
        }
    });
}

- (void)getSizeWithUrl:(NSString *)url onComplete:(void(^)(NSInteger size, NSString *url))complete{
    NSMutableURLRequest *mURLRequest;
    mURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [mURLRequest setHTTPMethod:@"HEAD"];
    mURLRequest.timeoutInterval = 5.0;
    
    // 1. 创建会话管理者
    AFURLSessionManager *manager = self.manager;
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:mURLRequest uploadProgress:nil downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"totalUnitCount = %lld, complete = %ld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
    }completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (complete) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ([response respondsToSelector:@selector(allHeaderFields)]) {
                NSDictionary *dictionary = [httpResponse allHeaderFields];
                complete([[dictionary objectForKey:@"Content-Length"] integerValue],url);
            }
        }
    }];
    [task resume];
}
@end
