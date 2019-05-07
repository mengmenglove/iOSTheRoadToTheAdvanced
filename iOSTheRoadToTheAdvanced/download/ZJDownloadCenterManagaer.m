//
//  ZJDownloadCenterManagaer.m
//  aizongjie
//
//  Created by huangbaoxian on 2019/3/20.
//  Copyright © 2019 wennzg. All rights reserved.
//

#import "ZJDownloadCenterManagaer.h"

#import "AFNetworking.h"


@interface ZJDownloadCenterManagaer ()

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

//@property (nonatomic, strong) NSMutableArray *taskArray;

@property (nonatomic, copy) NSString *downLoadUrl;


@property (nonatomic, strong) NSMutableArray *delegateArray;

@property (nonatomic, strong) NSMutableDictionary *downLoadTaskDict;

@property (nonatomic, strong) NSString *systemDownLoadPath;

@property (nonatomic, strong) NSString *currentDownLoadPath;

@end


static ZJDownloadCenterManagaer *_manager = nil;

@implementation ZJDownloadCenterManagaer
- (instancetype)init {
    if (self = [super init]) {
        [self getSystemDownloadPath];
        //        [self getTotleFileLength];
    }
    return self;
}


+ (ZJDownloadCenterManagaer *)getInstance {
    @synchronized (self) {
        if (!_manager) {
            _manager = [[ZJDownloadCenterManagaer alloc] init];
        }
        return _manager;
    }
}

- (void)addDelegate:(id<ZJDownloadCenterManagaerDelegate>)delegate {
    if (![self.delegateArray containsObject:delegate]) {
        [self.delegateArray addObject:delegate];
    }
}

- (void)removerDelegate:(id<ZJDownloadCenterManagaerDelegate>)delegate {
    if ([self.delegateArray containsObject:delegate]) {
        [self.delegateArray removeObject:delegate];
    }
}

- (void)downLoadFile:(NSString *)fileUrl; {
    if (fileUrl == nil) {
        return;
    }
    if (self.isDownloading) {
        [self.downLoadTaskDict setObject:@(PDFDownLoadDownLoading) forKey:fileUrl];
    }else {
        //检测文件是否存在
        BOOL isDownLoad = [self isDownloadFile:fileUrl];
        if (isDownLoad) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id<ZJDownloadCenterManagaerDelegate> delegate in self.delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(downloadPDFComplete: dataLength:)]) {
                        [delegate downloadPDFComplete:fileUrl dataLength:0];
                    }
                }
            });
            [self.downLoadTaskDict setObject:@(PDFDownLoadStatusComplete) forKey:fileUrl];
        }else {
            [self.downLoadTaskDict setObject:@(PDFDownLoadDownLoading) forKey:fileUrl];
            self.downLoadUrl = fileUrl;
            [self startDownLoad];
        }
    }
}


- (BOOL)isDownLoading:(NSString *)url {
    int status =  [[self.downLoadTaskDict objectForKey:url] intValue];
    if (status == PDFDownLoadDownLoading) {
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

- (PDFDownLoadStatus)getFileStatus:(NSString *)FileUrl {
    if (!FileUrl || FileUrl.length == 0) {
        return 0;
    }
    PDFDownLoadStatus status = 0;
    status = [[self.downLoadTaskDict objectForKey:FileUrl] intValue];
    if (status == 0) {
        BOOL isDownLoaded =  [self isDownloadFile:FileUrl];
        if (isDownLoaded) {
            [self.downLoadTaskDict setObject:@(PDFDownLoadStatusComplete) forKey:FileUrl];
            status = PDFDownLoadStatusComplete;
        }
    }
    return status;
}



- (void)startDownLoad {
    

    NSString *path = [self filePath:self.downLoadUrl];
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
    
    NSURL *url =  [NSURL URLWithString:self.downLoadUrl];
    
    // 2.创建request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置HTTP请求头中的Range
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    __weak typeof(self) weakSelf = self;
    _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [weakSelf.downLoadTaskDict setObject:@(PDFDownLoadStatusComplete) forKey:weakSelf.downLoadUrl ?: @""];
        weakSelf.isDownloading = NO;
        // 清空长度
        
        // 关闭fileHandle
        [weakSelf.fileHandle closeFile];
        weakSelf.fileHandle = nil;
        weakSelf.isDownloading = NO;
        
        if (weakSelf.delegateArray.count) {
            for (id<ZJDownloadCenterManagaerDelegate> delegate in weakSelf.delegateArray) {
                if (delegate && [delegate respondsToSelector:@selector(downloadPDFComplete: dataLength:)]) {
                    [delegate downloadPDFComplete:weakSelf.downLoadUrl dataLength:weakSelf.fileLength];
                }
            }
        }
        
        weakSelf.currentLength = 0;
        weakSelf.fileLength = 0;
        weakSelf.downLoadUrl = nil;
        
        for (NSString *urlKey in [weakSelf.downLoadTaskDict allKeys]) {
            int status = [[weakSelf.downLoadTaskDict objectForKey:urlKey] intValue];
            if (status == PDFDownLoadDownLoading) {
                weakSelf.downLoadUrl = urlKey;
                [weakSelf stopDownLoad];
                [weakSelf startDownLoad];
                break;
            }
        }
        
    }];
    
    [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        weakSelf.fileLength = response.expectedContentLength + weakSelf.currentLength;
        
        
        NSString *path = [weakSelf filePath:weakSelf.downLoadUrl];// [[MisManager shared] ZJGetValueForKey:[weakSelf.downLoadUrl md5]];
        // 沙盒文件路径
//        NSString *path = [[weakSelf getSystemDownloadPath] stringByAppendingPathComponent:[weakSelf getFileName:weakSelf.downLoadUrl]];
        
        NSLog(@"downloadPath: %@",path);
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
        
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            if (weakSelf.delegateArray.count) {
                for (id<ZJDownloadCenterManagaerDelegate> delegate in weakSelf.delegateArray) {
                    if (delegate && [delegate respondsToSelector:@selector(downloadProgress:url:currentSize:totleSize:)]) {
                        [delegate downloadProgress:progre url:weakSelf.downLoadUrl currentSize:weakSelf.currentLength totleSize:weakSelf.fileLength];
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

- (void)getTotleFileLength {
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString *path = self.systemDownLoadPath;
    
    float folderSize = 0.0;
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        
        for (NSString *fileName in childerFiles) {
            
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            NSLog(@"fileName %@",fileName);
            NSError *error = nil;
            NSDictionary *arrbute = [fileManager attributesOfItemAtPath:absolutePath error:&error];
            NSNumber *theFileSize;
            if (arrbute && [arrbute objectForKey:NSFileSize]) {
                folderSize += [theFileSize floatValue];
            }
        }
    }
    //SDWebImage框架自身计算缓存的实现
//    folderSize+=[[SDImageCache sharedImageCache] getSize];
}



- (BOOL)isDownloadFile:(NSString *)fileUrl {
    NSString * fileName = [self getFileName:fileUrl];
    NSString *path =  [NSString stringWithFormat:@"%@%@",self.systemDownLoadPath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

- (NSString *)getFileName:(NSString *)url {
    NSString *fileName = url;//[NSString stringWithFormat:@"%@.%@", [url md5], [url pathExtension]];
    NSLog(@"downLoadFileName : %@ url: %@",fileName, url);
    return fileName;
}

- (BOOL)removeFileWith:(NSString *)url {
    [self.downLoadTaskDict removeObjectForKey: url?: @""];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self getFileName:url];
    
    NSString *path = [NSString stringWithFormat:@"%@%@", self.systemDownLoadPath, fileName];
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

- (NSString *)filePath:(NSString *)url {
    NSString * fileName = nil;//[NSString stringWithFormat:@"%@.pdf",[url md5]];
    fileName = [self getFileName:url];
    NSString *path = [NSString stringWithFormat:@"%@%@", self.systemDownLoadPath, fileName];
    return path;
}

- (NSString *)getSystemDownloadPath {
    if (self.systemDownLoadPath) {
        return self.systemDownLoadPath;
    }
    self.systemDownLoadPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/zjDownLoader"];
    return self.systemDownLoadPath;
}



- (NSMutableArray *)delegateArray {
    if (!_delegateArray) {
        _delegateArray = [[NSMutableArray alloc] init];
    }
    return _delegateArray;
}

- (NSMutableDictionary *)downLoadTaskDict {
    if (!_downLoadTaskDict) {
        _downLoadTaskDict = [[NSMutableDictionary alloc] init];
    }
    return _downLoadTaskDict;
}



@end
