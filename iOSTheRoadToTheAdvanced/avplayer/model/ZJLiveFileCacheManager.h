//
//  ZJLiveFileCacheManager.h
//  aizongjie
//
//  Created by huangbaoxian on 2019/10/10.
//  Copyright © 2019 wennzg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FileDownLoadStatus) {
    FileDownLoadStatusNotExist = 1,
    FileDownLoadDownLoading = 2,
    FileDownLoadStatusPause = 3,
    FileDownLoadStatusComplete = 4,
    FileDownLoadStatusError = 5,
    
};


@protocol ZJLiveFileCacheManagerDelegate <NSObject>

@optional
- (void)downloadProgress:(NSInteger)prpgress url:(NSString *)downLoadUrl;
- (void)downloadComplete:(NSString *)downloadUrl;
@end


@interface ZJLiveFileCacheManager : NSObject

@property (nonatomic, strong) NSString *currentUrl;

+ (ZJLiveFileCacheManager *)getInstance;

- (void)downloadWithUrl:(NSString *)url delegate:(id<ZJLiveFileCacheManagerDelegate>)delegate;
- (void)stopDownLoad;

- (BOOL)isDownLoading:(NSString *)url;
- (NSString *)getFileName:(NSString *)url;
- (NSString *)getFilePath:(NSString *)fileUrl;
- (BOOL)isFileExistWithUrl:(NSString *)url;
- (BOOL)removeFileWith:(NSString *)url;
- (BOOL)isFileExist:(NSString *)fileUrl;
- (FileDownLoadStatus)getFileStatus:(NSString *)FileUrl;
- (void)cleanAllCache;


@end

NS_ASSUME_NONNULL_END
