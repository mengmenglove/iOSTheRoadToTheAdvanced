//
//  ZJScanViewController.m
//  aizongjie
//
//  Created by huangbaoxian on 2018/8/11.
//  Copyright © 2018年 wennzg. All rights reserved.
//

#import "ZJScanViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>



@interface ZJScanViewController ()

@end

@implementation ZJScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.style = [ZJScanViewController InnerStyle];
    self.view.backgroundColor = [UIColor blackColor];
    self.scanCodeType = SCT_QRCode;
    
    
   
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    [self requestCameraPemissionWithResult:^(BOOL granted) {
        
        if (granted) {
            
            //不延时，可能会导致界面黑屏并卡住一会
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.3];
            
        }else{
            
#ifdef LBXScan_Define_UI
            [_qRScanView stopDeviceReadying];
#endif
            
        }
    }];
    
}

//绘制扫描区域
- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
    }
    
    if (!_cameraInvokeMsg) {
        
        //        _cameraInvokeMsg = NSLocalizedString(@"wating...", nil);
    }
    
    [_qRScanView startDeviceReadyingWithText:_cameraInvokeMsg];
}


- (void)reStartDevice
{
    [_scanObj startScan];
    
}

//启动设备
- (void)startScan
{
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;
            if (!_scanObj )
            {
                CGRect cropRect = CGRectZero;
                
                if (_isOpenInterestRect) {
                    
                    //设置只识别框内区域
                    cropRect = [LBXScanView getScanRectWithPreView:self.view style:_style];
                }
                
                NSString *strCode = AVMetadataObjectTypeQRCode;
                if (_scanCodeType != SCT_BarCodeITF ) {
                    
                    strCode = [self nativeCodeWithType:_scanCodeType];
                }
                
                //AVMetadataObjectTypeITF14Code 扫码效果不行,另外只能输入一个码制，虽然接口是可以输入多个码制
                self.scanObj = [[LBXScanNative alloc]initWithPreView:videoView ObjectType:@[strCode] cropRect:cropRect success:^(NSArray<LBXScanResult *> *array) {
                    
                    [weakSelf scanResultWithArray:array];
                }];
                [_scanObj setNeedCaptureImage:_isNeedScanImage];
            }
            [_scanObj startScan];

    
#ifdef LBXScan_Define_UI
    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];
#endif
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self stopScan];
    
#ifdef LBXScan_Define_UI
    [_qRScanView stopScanAnimation];
#endif
}

- (void)stopScan
{
    
     [_scanObj stopScan];
    
}

#pragma mark -扫码结果处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    //设置了委托的处理
    if (_delegate) {
        [_delegate scanResultWithArray:array];
    }
      LBXScanResult *result = array.firstObject;
    
    
    
    //也可以通过继承LBXScanViewController，重写本方法即可
}

- (NSDictionary *)getUrlParamDict:(NSString *)paramUrl {

        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];
        //获取问号的位置，问号后是参数列表
        NSRange range = [paramUrl rangeOfString:@"?"];
        //获取参数列表
        NSString *propertys = [paramUrl substringFromIndex:(int)(range.location+1)];
    
        //进行字符串的拆分，通过&来拆分，把每个参数分开
        NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    
        for (int j = 0 ; j < subArray.count; j++)
        {
            //在通过=拆分键和值
            NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
            [tempDic setObject:dicArray[1] forKey:dicArray[0]];
        }
        NSLog(@"打印参数列表生成的字典：\n%@", tempDic);
           
    
    return tempDic;
}

//开关闪光灯
- (void)openOrCloseFlash
{
    
    [_scanObj changeTorch];
    self.isOpenFlash =!self.isOpenFlash;
}


#pragma mark --打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto:(BOOL)allowsEditing
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}



//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
    }
    else
    {
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)nativeCodeWithType:(SCANCODETYPE)type
{
    switch (type) {
        case SCT_QRCode:
            return AVMetadataObjectTypeQRCode;
            break;
        case SCT_BarCode93:
            return AVMetadataObjectTypeCode93Code;
            break;
        case SCT_BarCode128:
            return AVMetadataObjectTypeCode128Code;
            break;
        case SCT_BarCodeITF:
            return @"ITF条码:only ZXing支持";
            break;
        case SCT_BarEAN13:
            return AVMetadataObjectTypeEAN13Code;
            break;
            
        default:
            return AVMetadataObjectTypeQRCode;
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (granted) {
                                                     completion(true);
                                                 } else {
                                                     completion(false);
                                                 }
                                             });
                                             
                                         }];
            }
                break;
                
        }
    }
    
    
}

+ (BOOL)photoPermission
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if ( author == ALAuthorizationStatusDenied ) {
            
            return NO;
        }
        return YES;
    }
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        
        return NO;
    }
    return YES;
}

#pragma mark -无边框，内嵌4个角
+ (LBXScanViewStyle*)InnerStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    
    return style;
}

@end
