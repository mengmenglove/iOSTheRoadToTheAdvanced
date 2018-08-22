//
//  RemoveImageRedPointViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/8/20.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "RemoveImageRedPointViewController.h"

@interface RemoveImageRedPointViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *showImageView;


@end

@implementation RemoveImageRedPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.showImageView];
    CGRect frame = self.showImageView.frame;
    frame.origin = CGPointMake(0, 64);
    self.showImageView.frame = frame;
    
    self.image = [UIImage imageNamed:@"1532946340216"];
    
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc] initWithTitle:@"去红"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(blackAndWhite)];
    
    
    UIBarButtonItem *tokePhotoItem = [[UIBarButtonItem alloc] initWithTitle:@"拍照"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(takePhoto)];
    
    self.navigationItem.rightBarButtonItems = @[rigthItem , tokePhotoItem];
    
    self.showImageView.image = self.image;
    
    // Do any additional setup after loading the view.
}

- (void)takePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:true completion:^{
        
    }];
}

- (void)removeRedClick {
    __weak typeof(self) weakSelf = self;
    [self imageRemoveRedOrGreenOrigin:self.image param:4 complete:^(UIImage *image) {
        weakSelf.showImageView.image = image;
    }];
}


- (void)blackAndWhite {
    __weak typeof(self) weakSelf = self;
    [self drawImage:150  image:self.image  complete:^(UIImage *resultImage) {
        weakSelf.showImageView.image  = resultImage;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image = image;
    self.showImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)drawImage:(double)filterValue image:(UIImage *)handleImage  complete:(handleImageCompleteBlock)complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"开始处理");
        UIImage *image = handleImage;
        // 分配内存
        const int imageWidth = image.size.width;
        const int imageHeight = image.size.height;
        size_t      bytesPerRow = imageWidth * 4;
        uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
        
        // 创建context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
        CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
        // 遍历像素
        int pixelNum = imageWidth * imageHeight;
        uint32_t* pCurPtr = rgbImageBuf;
        
        for (int i = 0; i < pixelNum; i++, pCurPtr++)
        {
            //      ABGR
            uint8_t* ptr = (uint8_t*)pCurPtr;
            int B = ptr[1];
            int G = ptr[2];
            int R = ptr[3];
            double Gray = R*0.3+G*0.59+B*0.11;
            if (Gray > filterValue || (Gray == filterValue && filterValue == 0)) {
                ptr[0] = 255;
                ptr[1] = 255;
                ptr[2] = 255;
            }else{
                ptr[0] = 0;
                ptr[1] = 0;
                ptr[2] = 0;
                //            ptr[3] = 0xff;
            }
        }
        // 将内存转成image
        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,NULL);
        CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
        
        CGDataProviderRelease(dataProvider);
        
        UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        // 释放
        CGImageRelease(imageRef);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        NSLog(@"处理完成");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(resultUIImage);
            }
        });
    });
   // self.outputImg.image = resultUIImage;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***
 
 去红去蓝算法
 
 **/

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )


- (void)imageRemoveRedOrGreenOrigin:(UIImage *)originImage  param:(int)param  complete:(handleImageCompleteBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1. Get the raw pixels of the image
        UInt32 *inputPixels;
//        UInt32 *maskPixels;
        
        //原始图片
//        CGImageRef maskCGImage = [originImage CGImage]; //蒙板图片
        //修改之后的图片
        CGImageRef inputCGImage = [originImage CGImage];//准备被裁剪的图片
        NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
        NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        NSUInteger bytesPerPixel = 4;
        NSUInteger bitsPerComponent = 8;
        
        NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
        
        inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
//        maskPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
        //被裁剪图片的上下文
        CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                     bitsPerComponent, inputBytesPerRow, colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
        //蒙板图片的上下文
//        CGContextRef maskContext = CGBitmapContextCreate(maskPixels, inputWidth, inputHeight,
//                                                         bitsPerComponent, inputBytesPerRow, colorSpace,
//                                                         kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//        CGContextDrawImage(maskContext, CGRectMake(0, 0, inputWidth, inputHeight), maskCGImage);
        
        // 3. Convert the image
        for (NSUInteger j = 0; j < inputHeight; j++) {
            for (NSUInteger i = 0; i < inputWidth; i++) {
                //修改之后的图片
                UInt32 * currentPixel = inputPixels + (j * inputWidth) + i;
                //原始图片
//                UInt32 * currentMaskPixel = maskPixels + (j * inputWidth) + i;
                UInt32 color = *currentPixel;
                NSInteger red = R(color);
                NSInteger green = G(color);
                NSInteger blue = B(color);
                
                if (green < 210 && ((red >= 100 && red > MAX(green, blue)
                                     && red > green + 15) || (red < 100 && red > MAX(green, blue) && red > green + 30))) {
                    if (param == 4) {
                        *currentPixel = RGBAMake(255, 255, 255, 1);
                    }
                    
                } else if (MAX(MAX(green, blue), red) < 150 && MAX(MAX(green, blue), red) - MIN(MIN(green, blue), red) < 20) {
                    //                *currentPixel = RGBAMake(0, 0, 0, 1);
                } else if (blue > 240 || blue > MAX(red, green)) {
                    if (param == 5) {
                        *currentPixel = RGBAMake(255, 255, 255, 1);
                    }
                }
            }//裁剪
        }
        // 4. Create a new UIImage
        CGImageRef newCGImage = CGBitmapContextCreateImage(context);
        UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
        // 5. Cleanup!
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
//        CGContextRelease(maskContext);
        free(inputPixels);
//        free(maskPixels);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(processedImage);
            }
        });
    });
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _showImageView;
}

@end
