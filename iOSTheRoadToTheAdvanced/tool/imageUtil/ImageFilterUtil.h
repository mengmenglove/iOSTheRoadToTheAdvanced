//
//  ImageFilterUtil.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageFilterUtil : NSObject
/*
 * 使用色彩值将图片覆盖 250全变白  0 没有变化
 */
+ (UIImage*)brightenWithValue:(float)value image:(UIImage *)valueImage;

+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type;

+ (UIImage*)grayHandlescale:(UIImage*)anImage type:(int)type;
+ (UIImage *)changePicColorPartial:(UIImage *)image;


@end
