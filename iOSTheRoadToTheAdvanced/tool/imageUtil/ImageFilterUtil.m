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


+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type {
    
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                brightness = (77 * red + 28 * green + 151 * blue) /  256;
                brightness = brightness/3;
                *(tmp + 0) = brightness;
                *(tmp + 1) = brightness;
                *(tmp + 2) = brightness;
                break;
                case 2:
                *(tmp + 0) = red;
                *(tmp + 1) = green * 0.7;
                *(tmp + 2) = blue * 0.4;
                break;
                case 3:
                *(tmp + 0) = 255 - red;
                *(tmp + 1) = 255 - green;
                *(tmp + 2) = 255 - blue;
                break;
                case 4:
                *(tmp + 0) = 0;
                *(tmp + 1) = green;
                *(tmp + 2) = blue;
                break;
                default:
                *(tmp + 0) = red;
                *(tmp + 1) = green;
                *(tmp + 2) = blue;
                break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage scale:1 orientation:anImage.imageOrientation];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
    
}


+ (UIImage*)grayHandlescale:(UIImage*)input type:(int)type {
    
    
    CIImage * inputCIImage = [[CIImage alloc] initWithImage:input];
    // 1. Create a grayscale filter
    CIFilter * grayFilter = [CIFilter filterWithName:@"CIColorControls"];
    [grayFilter setValue:@(0) forKeyPath:@"inputSaturation"];
    // 2. Create your ghost filter
    // Use Core Graphics for this
    UIImage * ghostImage = input;
    CIImage * ghostCIImage = [[CIImage alloc] initWithImage:ghostImage];
    // 3. Apply alpha to Ghosty
    CIFilter * alphaFilter = [CIFilter filterWithName:@"CIColorMatrix"];
    CIVector * alphaVector = [CIVector vectorWithX:0 Y:0 Z:0.5 W:0];
    [alphaFilter setValue:alphaVector forKeyPath:@"inputAVector"];
    // 4. Alpha blend filter
    CIFilter * blendFilter = [CIFilter filterWithName:@"CISourceAtopCompositing"];
    // 5. Apply your filters
    [alphaFilter setValue:ghostCIImage forKeyPath:@"inputImage"];
    ghostCIImage = [alphaFilter outputImage];
    [blendFilter setValue:ghostCIImage forKeyPath:@"inputImage"];
    [blendFilter setValue:inputCIImage forKeyPath:@"inputBackgroundImage"];
    CIImage * blendOutput = [blendFilter outputImage];
    [grayFilter setValue:blendOutput forKeyPath:@"inputImage"];
    CIImage * outputCIImage = [grayFilter outputImage];
    // 6. Render your output image
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef outputCGImage = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    UIImage * outputImage = [UIImage imageWithCGImage:outputCGImage];
    CGImageRelease(outputCGImage);
    return outputImage;
    
    
    
    
    
    
    /*
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) /  256;
//                    brightness = brightness/3;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                case 4:
                    *(tmp + 0) = 0;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage scale:1 orientation:anImage.imageOrientation];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
 */
    
}

+ (UIImage *)changePicColorPartial:(UIImage *)image{
    //1.get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger imageW = CGImageGetWidth(imageRef);
    NSUInteger imageH = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;//一个像素四个分量，即ARGB
    NSUInteger bytesPerRow = bytesPerPixel * imageW;
    unsigned char *rawData = (unsigned char *)calloc(imageH*imageW*bytesPerPixel, sizeof(unsigned char));
    NSUInteger bitsPerComponent = 8;//每个分量8个字节
    CGContextRef context = CGBitmapContextCreate(rawData, imageW, imageH, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, imageW, imageH), imageRef);
    
    //2.Now your rawData contains the image data int the RGBA8888 pixel format
    for (int y = 0; y < imageH; y++) {
        for (int x = 0; x < imageW; x++) {
            NSUInteger byteIndex = bytesPerRow*y + bytesPerPixel*x;
            //rawData一维数组存储方式RGBA(第一个像素)RGBA(第二个像素)
            NSUInteger red = rawData[byteIndex];
            NSUInteger green = rawData[byteIndex+1];
            NSUInteger blue = rawData[byteIndex+2];
            NSUInteger alpha = rawData[byteIndex+3];
             if(red+green+blue == 255*3 && (alpha/255.0 >= 0.5)){//白色部分
                rawData[byteIndex] = 255;
                rawData[byteIndex+1] = 255;
                rawData[byteIndex+2] = 255;
                rawData[byteIndex+3] = 255;
             }else if (red+green+blue == 0 && (alpha/255.0 >= 0.5)) {//黑色部分
                 rawData[byteIndex] = 0;
                 rawData[byteIndex+1] = 0;
                 rawData[byteIndex+2] = 0;
                 rawData[byteIndex+3] = 0;
             }
        }
    }
    imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(rawData);
    return [UIImage imageWithCGImage:imageRef scale:1.0 orientation:image.imageOrientation];
}


+ (UIImage *)removeRedGreen:(UIImage *)image {
    //1.get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger imageW = CGImageGetWidth(imageRef);
    NSUInteger imageH = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;//一个像素四个分量，即ARGB
    NSUInteger bytesPerRow = bytesPerPixel * imageW;
    unsigned char *rawData = (unsigned char *)calloc(imageH*imageW*bytesPerPixel, sizeof(unsigned char));
    NSUInteger bitsPerComponent = 8;//每个分量8个字节
    CGContextRef context = CGBitmapContextCreate(rawData, imageW, imageH, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, imageW, imageH), imageRef);
    
    //2.Now your rawData contains the image data int the RGBA8888 pixel format
    for (int y = 0; y < imageH; y++) {
        for (int x = 0; x < imageW; x++) {
            NSUInteger byteIndex = bytesPerRow*y + bytesPerPixel*x;
            //rawData一维数组存储方式RGBA(第一个像素)RGBA(第二个像素)
            NSUInteger red = rawData[byteIndex];
            NSUInteger green = rawData[byteIndex+1];
            NSUInteger blue = rawData[byteIndex+2];
            NSUInteger alpha = rawData[byteIndex+3];
           
            if ((green < 210) && (((red >= 100) && (red > MAX(green, blue)) && (red > green + 15)) || ((red < 100) && (red > MAX(green, blue)) && (red > green + 30)))) {
                  rawData[byteIndex] = 1;
            }else {
                
                if ((MAX(MAX(green, blue), red) < 150) && (MAX(MAX(green, blue), red) - MIN(MIN(green, blue), red) < 20)) {
                   rawData[byteIndex] = 0;
                } else if ((blue > 240) || (blue > MAX(red, green))) {
                   rawData[byteIndex] = 2;
                }
            }
        }
    }
    imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(rawData);
    return [UIImage imageWithCGImage:imageRef scale:1.0 orientation:image.imageOrientation];
}




@end
