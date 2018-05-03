//
//  ImageBlurring.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ImageBlurring : NSObject
/*
 * 图片模糊
 */
+ (UIImage*)gaussianBlurWithBias:(NSInteger)bias valueImg:(UIImage *)valueImage;
@end
