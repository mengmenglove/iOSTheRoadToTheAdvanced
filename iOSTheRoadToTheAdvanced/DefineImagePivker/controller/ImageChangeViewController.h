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
    buttonActionTypeRemoveRed,
    buttonActionTypeRemoveBlue,
    buttonActionTypeReduceNoice,
    buttonActionTypeSuccess,
};


@interface ImageChangeViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@end



@interface ButtonModel: NSObject

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;

+ (ButtonModel *)initWithTitle:(NSString *)title icon:(NSString *)icon;

@end
