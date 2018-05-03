//
//  ImageResizing.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ImageResizing.h"
#import "NYXImagesHelper.h"


@implementation ImageResizing
+ (UIImage*)cropToSize:(CGSize)newSize usingMode:(NYXCropMode)cropMode image:(UIImage *)image {
    
    const CGSize size = image.size;
    CGFloat x, y;
    switch (cropMode)
    {
        case NYXCropModeTopLeft:
            x = y = 0.0f;
            break;
        case NYXCropModeTopCenter:
            x = (size.width - newSize.width) * 0.5f;
            y = 0.0f;
            break;
        case NYXCropModeTopRight:
            x = size.width - newSize.width;
            y = 0.0f;
            break;
        case NYXCropModeBottomLeft:
            x = 0.0f;
            y = size.height - newSize.height;
            break;
        case NYXCropModeBottomCenter:
            x = (size.width - newSize.width) * 0.5f;
            y = size.height - newSize.height;
            break;
        case NYXCropModeBottomRight:
            x = size.width - newSize.width;
            y = size.height - newSize.height;
            break;
        case NYXCropModeLeftCenter:
            x = 0.0f;
            y = (size.height - newSize.height) * 0.5f;
            break;
        case NYXCropModeRightCenter:
            x = size.width - newSize.width;
            y = (size.height - newSize.height) * 0.5f;
            break;
        case NYXCropModeCenter:
            x = (size.width - newSize.width) * 0.5f;
            y = (size.height - newSize.height) * 0.5f;
            break;
        default: // Default to top left
            x = y = 0.0f;
            break;
    }
    
    if (image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationLeftMirrored || image.imageOrientation == UIImageOrientationRight || image.imageOrientation == UIImageOrientationRightMirrored)
    {
        CGFloat temp = x;
        x = y;
        y = temp;
        
        temp = newSize.width;
        newSize.width = newSize.height;
        newSize.height = temp;
    }
    
    CGRect cropRect = CGRectMake(x * image.scale, y * image.scale, newSize.width * image.scale, newSize.height * image.scale);
    
    /// Create the cropped image
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage* cropped = [UIImage imageWithCGImage:croppedImageRef scale:image.scale orientation:image.imageOrientation];
    
    /// Cleanup
    CGImageRelease(croppedImageRef);
    
    return cropped;
}

// NYXCropModeTopLeft crop mode used
+ (UIImage*)cropToSize:(CGSize)newSize image:(UIImage *)image {
    return [ImageResizing cropToSize:newSize usingMode:NYXCropModeTopLeft image:image];
}

+ (UIImage*)scaleByFactor:(float)scaleFactor image:(UIImage *)image {
    
    CGSize scaledSize = CGSizeMake(image.size.width * scaleFactor, image.size.height * scaleFactor);
    return [ImageResizing scaleToFillSize:scaledSize image:image];
    
}

+ (UIImage*)scaleToSize:(CGSize)newSize usingMode:(NYXResizeMode)resizeMode image:(UIImage *)image {
    
    switch (resizeMode)
    {
        case NYXResizeModeAspectFit:
            return [ImageResizing scaleToFitSize:newSize image:image];
        case NYXResizeModeAspectFill:
            return [ImageResizing scaleToCoverSize:newSize image:image];
        default:
            return [ImageResizing scaleToFillSize:newSize image:image];
    }
    
}

// NYXResizeModeScaleToFill resize mode used
+ (UIImage*)scaleToSize:(CGSize)newSize image:(UIImage *)image {
    
    return [ImageResizing scaleToFillSize:newSize image:image];
}

// Same as 'scale to fill' in IB.
+ (UIImage*)scaleToFillSize:(CGSize)newSize image:(UIImage *)image {
    
    size_t destWidth = (size_t)(newSize.width * image.scale);
    size_t destHeight = (size_t)(newSize.height * image.scale);
    if (image.imageOrientation == UIImageOrientationLeft
        || image.imageOrientation == UIImageOrientationLeftMirrored
        || image.imageOrientation == UIImageOrientationRight
        || image.imageOrientation == UIImageOrientationRightMirrored)
    {
        size_t temp = destWidth;
        destWidth = destHeight;
        destHeight = temp;
    }
    
    /// Create an ARGB bitmap context
    CGContextRef bmContext = NYXCreateARGBBitmapContext(destWidth, destHeight, destWidth * kNyxNumberOfComponentsPerARBGPixel, NYXImageHasAlpha(image.CGImage));
    if (!bmContext)
        return nil;
    
    /// Image quality
    CGContextSetShouldAntialias(bmContext, true);
    CGContextSetAllowsAntialiasing(bmContext, true);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
    /// Draw the image in the bitmap context
    
    UIGraphicsPushContext(bmContext);
    CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), image.CGImage);
    UIGraphicsPopContext();
    
    /// Create an image object from the context
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:image.scale orientation:image.imageOrientation];
    
    /// Cleanup
    CGImageRelease(scaledImageRef);
    CGContextRelease(bmContext);
    
    return scaled;
}

// Preserves aspect ratio. Same as 'aspect fit' in IB.
+ (UIImage*)scaleToFitSize:(CGSize)newSize image:(UIImage *)image {
    /// Keep aspect ratio
    size_t destWidth, destHeight;
    if (image.size.width > image.size.height)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(image.size.height * newSize.width / image.size.width);
    }
    else
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(image.size.width * newSize.height / image.size.height);
    }
    if (destWidth > newSize.width)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(image.size.height * newSize.width / image.size.width);
    }
    if (destHeight > newSize.height)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(image.size.width * newSize.height / image.size.height);
    }
    return [ImageResizing scaleToFillSize:CGSizeMake(destWidth, destHeight) image:image];
    
}

// Preserves aspect ratio. Same as 'aspect fill' in IB.
+ (UIImage*)scaleToCoverSize:(CGSize)newSize image:(UIImage *)image {
    size_t destWidth, destHeight;
    CGFloat widthRatio = newSize.width / image.size.width;
    CGFloat heightRatio = newSize.height / image.size.height;
    /// Keep aspect ratio
    if (heightRatio > widthRatio)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(image.size.width * newSize.height / image.size.height);
    }
    else
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(image.size.height * newSize.width / image.size.width);
    }
    return [ImageResizing scaleToFillSize:CGSizeMake(destWidth, destHeight) image:image];
    
    
}
@end
