//
//  ZJTKImageView.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/4.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTKImageView : UIView

@property (nonatomic, strong) UIImage *clipImage;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
