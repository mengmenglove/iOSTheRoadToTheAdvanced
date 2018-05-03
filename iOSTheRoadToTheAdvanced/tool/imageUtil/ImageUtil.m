//
//  ImageUtil.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ImageUtil.h"
#import <ImageIO/ImageIO.h>


@implementation ImageUtil

// 角度转换
+ (CGFloat)degreeToRadian:(CGFloat)degree
{
    return degree * M_PI / 180;
};


// 向右旋转角度
+ (UIImage *)rotateRightWithImage:(UIImage *)image degree:(CGFloat)degree
{
    CGFloat radian = [ImageUtil degreeToRadian:degree];
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radian);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    //    UIGraphicsBeginImageContext(rotatedSize);
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize,NO,2.0);
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, radian);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2,
                                          -image.size.height / 2,
                                          image.size.width,
                                          image.size.height),
                       [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
