//
//  ImageFilterUtil.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ImageFilterUtil.h"
#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
#import <ImageIO/ImageIO.h>
#import "NYXImagesHelper.h"


@implementation ImageFilterUtil

+ (UIImage*)brightenWithValue:(float)value image:(UIImage *)valueImage
{
    /// Create an ARGB bitmap context
    const size_t width = (size_t)valueImage.size.width;
    const size_t height = (size_t)valueImage.size.height;
    CGContextRef bmContext = NYXCreateARGBBitmapContext(width, height, width * kNyxNumberOfComponentsPerARBGPixel, NYXImageHasAlpha(valueImage.CGImage));
    if (!bmContext)
        return nil;
    
    /// Draw the image in the bitmap context
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, valueImage.CGImage);
    
    /// Grab the image raw data
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data)
    {
        CGContextRelease(bmContext);
        return nil;
    }
    
    const size_t pixelsCount = width * height;
    float* dataAsFloat = (float*)malloc(sizeof(float) * pixelsCount);
    float min = (float)kNyxMinPixelComponentValue, max = (float)kNyxMaxPixelComponentValue;
    
    /// Calculate red components
    vDSP_vfltu8(data + 1, 4, dataAsFloat, 1, pixelsCount);
    vDSP_vsadd(dataAsFloat, 1, &value, dataAsFloat, 1, pixelsCount);
    vDSP_vclip(dataAsFloat, 1, &min, &max, dataAsFloat, 1, pixelsCount);
    vDSP_vfixu8(dataAsFloat, 1, data + 1, 4, pixelsCount);
    
    /// Calculate green components
    vDSP_vfltu8(data + 2, 4, dataAsFloat, 1, pixelsCount);
    vDSP_vsadd(dataAsFloat, 1, &value, dataAsFloat, 1, pixelsCount);
    vDSP_vclip(dataAsFloat, 1, &min, &max, dataAsFloat, 1, pixelsCount);
    vDSP_vfixu8(dataAsFloat, 1, data + 2, 4, pixelsCount);
    
    /// Calculate blue components
    vDSP_vfltu8(data + 3, 4, dataAsFloat, 1, pixelsCount);
    vDSP_vsadd(dataAsFloat, 1, &value, dataAsFloat, 1, pixelsCount);
    vDSP_vclip(dataAsFloat, 1, &min, &max, dataAsFloat, 1, pixelsCount);
    vDSP_vfixu8(dataAsFloat, 1, data + 3, 4, pixelsCount);
    
    CGImageRef brightenedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* brightened = [UIImage imageWithCGImage:brightenedImageRef scale:valueImage.scale orientation:valueImage.imageOrientation];
    
    /// Cleanup
    CGImageRelease(brightenedImageRef);
    free(dataAsFloat);
    CGContextRelease(bmContext);
    
    return brightened;
}

@end
