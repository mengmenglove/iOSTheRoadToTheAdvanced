//
//  ZJScanViewController.h
//  aizongjie
//
//  Created by huangbaoxian on 2018/8/11.
//  Copyright © 2018年 wennzg. All rights reserved.
//

#import "LBXScanTypes.h"
#import "LBXScanViewStyle.h"
#import "LBXScanNative.h"
#import "LBXScanView.h"


// @[@"QRCode",@"BarCode93",@"BarCode128",@"BarCodeITF",@"EAN13"];
typedef NS_ENUM(NSInteger, SCANCODETYPE) {
    SCT_QRCode, //QR二维码
    SCT_BarCode93,
    SCT_BarCode128,//支付条形码(支付宝、微信支付条形码)
    SCT_BarCodeITF,//燃气回执联 条形码?
    SCT_BarEAN13 //一般用做商品码
};

@protocol LBXScanViewControllerDelegate <NSObject>
@optional
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array;
@end

@interface ZJScanViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>



//

/**
 当前选择的识别码制
 - ZXing暂不支持类型选择
 */
@property (nonatomic, assign) SCANCODETYPE scanCodeType;



//扫码结果委托，另外一种方案是通过继承本控制器，override方法scanResultWithArray即可
@property (nonatomic, weak) id<LBXScanViewControllerDelegate> delegate;


/**
 @brief 是否需要扫码图像
 */
@property (nonatomic, assign) BOOL isNeedScanImage;



/**
 @brief  启动区域识别功能，ZBar暂不支持
 */
@property(nonatomic,assign) BOOL isOpenInterestRect;


/**
 相机启动提示,如 相机启动中...
 */
@property (nonatomic, copy) NSString *cameraInvokeMsg;



@property (nonatomic, strong) LBXScanViewStyle *style;

@property (nonatomic,strong) LBXScanNative* scanObj;

#pragma mark - 扫码界面效果及提示等
/**
 @brief  扫码区域视图,二维码一般都是框
 */

#ifdef LBXScan_Define_UI
@property (nonatomic,strong) LBXScanView* qRScanView;
#endif


/**
 @brief  扫码存储的当前图片
 */
@property(nonatomic,strong) UIImage* scanImage;


/**
 @brief  闪关灯开启状态记录
 */
@property(nonatomic,assign)BOOL isOpenFlash;





//打开相册
- (void)openLocalPhoto:(BOOL)allowsEditing;

//开关闪光灯
- (void)openOrCloseFlash;

//启动扫描
- (void)reStartDevice;

//关闭扫描
- (void)stopScan;


@end
