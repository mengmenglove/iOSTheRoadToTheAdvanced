//
//  ZJDownloadCenterManagaer.h
//  aizongjie
//
//  Created by huangbaoxian on 2019/3/20.
//  Copyright © 2019 wennzg. All rights reserved.
//



typedef NS_ENUM(NSUInteger, PDFDownLoadStatus) {
    PDFDownLoadStatusNotExist = 1,
    PDFDownLoadDownLoading = 2,
    PDFDownLoadStatusPause = 3,
    PDFDownLoadStatusComplete = 4,
    PDFDownLoadStatusError = 5,
    
};



#import <Foundation/Foundation.h>

@protocol ZJDownloadCenterManagaerDelegate <NSObject>

@optional

- (void)downloadProgress:(NSInteger)prpgress url:(NSString *)downLoadUrl currentSize:(NSInteger)currentSize totleSize:(NSInteger)totle;
//- (void)downloadProgress:(NSInteger)prpgress url:(NSString *)downLoadUrl;
//
//- (void)downloadTotle:(NSInteger)totle currentSize:(NSInteger)current  url:(NSString *)downLoadUrl;

- (void)downloadPDFComplete:(NSString *)completeUrl dataLength:(NSInteger)length;

@end

@interface ZJDownloadCenterManagaer : NSObject


+ (ZJDownloadCenterManagaer *)getInstance;
- (void)addDelegate:(id<ZJDownloadCenterManagaerDelegate>)delegate;
- (void)removerDelegate:(id<ZJDownloadCenterManagaerDelegate>)delegate;

- (void)downLoadFile:(NSString *)fileUrl;
- (void)stopDownLoad;
- (BOOL)isDownloadFile:(NSString *)fileUrl;
- (BOOL)isDownLoading:(NSString *)url;
- (NSString *)getFileName:(NSString *)url;
- (NSString *)filePath:(NSString *)url;
- (PDFDownLoadStatus)getFileStatus:(NSString *)FileUrl;
- (BOOL)removeFileWith:(NSString *)url;
- (NSInteger)getFileLength:(NSString *)fileUrl;

- (void)getTotleFileLength;

@end


