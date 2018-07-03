//
//  ZJDrawTool.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawType) {
    DrawTypeLine,
    DrawTypeRectView,
    DrawTypeUnKown,
};

@interface ZJDrawPath : NSObject

@property (nonatomic, strong) CAShapeLayer *shape;
@property (nonatomic, strong) UIColor *pathColor;//画笔颜色
+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth;
- (void)pathLineToPoint:(CGPoint)movePoint;//画
- (void)drawPath;//绘制

@end


@interface ZJDrawTool : NSObject
@property (nonatomic, assign) DrawType type;
@property (nonatomic, strong) NSMutableArray *allPathArray;
@property (nonatomic, strong) NSMutableArray *allRectViewArray;
@property (nonatomic, strong) NSMutableArray *actionArray;
@property (nonatomic, assign) CGFloat pathWidth;
@property (nonatomic, strong) UIColor *pathColor;

- (instancetype)initWithDrawView:(UIImageView *)imageView;

- (void)backToLastDraw;

- (void)drawLine;


@end



