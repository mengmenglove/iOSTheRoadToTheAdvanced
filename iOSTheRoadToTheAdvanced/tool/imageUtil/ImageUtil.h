//
//  ImageUtil.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class UIImage;

@interface ImageUtil : NSObject

/*
 *  旋转角度
 *   @param
 *   image 需要处理的图片
 *   degree 旋转的角度  example 旋转270度 => (degree= 270 - 180)
 */
+ (UIImage *)rotateRightWithImage:(UIImage *)image degree:(CGFloat)degree;

/*
 * 截图
 */

@end
