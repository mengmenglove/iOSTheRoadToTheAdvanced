//
//  ImageResizing.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    NYXCropModeTopLeft,
    NYXCropModeTopCenter,
    NYXCropModeTopRight,
    NYXCropModeBottomLeft,
    NYXCropModeBottomCenter,
    NYXCropModeBottomRight,
    NYXCropModeLeftCenter,
    NYXCropModeRightCenter,
    NYXCropModeCenter
} NYXCropMode;

typedef enum
{
    NYXResizeModeScaleToFill,
    NYXResizeModeAspectFit,
    NYXResizeModeAspectFill
} NYXResizeMode;


@interface ImageResizing : NSObject


+ (UIImage*)cropToSize:(CGSize)newSize usingMode:(NYXCropMode)cropMode image:(UIImage *)image;
+ (UIImage*)scaleByFactor:(float)scaleFactor image:(UIImage *)image;
+ (UIImage*)scaleToSize:(CGSize)newSize usingMode:(NYXResizeMode)resizeMode image:(UIImage *)image;
+ (UIImage*)scaleToSize:(CGSize)newSize image:(UIImage *)image;
+ (UIImage*)scaleToFillSize:(CGSize)newSize image:(UIImage *)image;
+ (UIImage*)scaleToFitSize:(CGSize)newSize image:(UIImage *)image;
+ (UIImage*)scaleToCoverSize:(CGSize)newSize image:(UIImage *)image;



@end
