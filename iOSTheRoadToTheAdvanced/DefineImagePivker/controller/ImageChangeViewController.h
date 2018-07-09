//
//  ImageChangeViewController.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, buttonActionType) {
    buttonActionTypeClose,
    buttonActionTypeOrigin,
    buttonActionTypeNormal,
    buttonActionTypeRemoveRed,
    buttonActionTypeRemoveBlue,
    buttonActionTypeReduceNoice,
    buttonActionTypeColorSuccess,
    buttonActionTypeRemoveContentSmall,
    buttonActionTypeRemoveContentMid,
    buttonActionTypeRemoveContentLarge,
    buttonActionTypeRemoveContentRect,
    buttonActionTypeDrawSuccess,
    
};

typedef NS_ENUM(NSInteger, colorRange) {
    colorRangeNoRedGreen = 5,
    colorRangeNormal = 10,
    colorRangeReleaseVoice = 15,
};

typedef NS_ENUM(NSInteger, ImageEditType) {
    ImageEditTypeColor = 1,
    ImageEditTypeElement = 2,
    ImageEditTypeUnkown = 3,
};

@interface ImageChangeViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;


@end



@interface ButtonModel: NSObject

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;

@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, strong) UIColor *iconSelectedColor;

@property (nonatomic, assign) CGSize btnSize;


+ (ButtonModel *)initWithTitle:(NSString *)title icon:(NSString *)icon;

@end
