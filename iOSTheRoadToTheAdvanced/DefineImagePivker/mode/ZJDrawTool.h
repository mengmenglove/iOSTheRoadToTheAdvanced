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
@property (nonatomic, assign) DrawType type;
+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth;
+ (instancetype)pathToPoint:(CGPoint)beginPoint toEndPoint:(CGPoint)endPoint;
- (void)pathLineToPoint:(CGPoint)movePoint;//画
- (void)drawPath;//绘制

@end


@interface ZJDrawTool : NSObject
@property (nonatomic, assign) DrawType type;
@property (nonatomic, strong) NSMutableArray *allPathArray;
@property (nonatomic, assign) CGFloat pathWidth;
@property (nonatomic, strong) UIColor *pathColor;



- (instancetype)initWithDrawView:(UIImageView *)imageView;

- (void)backToLastDraw;

- (void)drawLine;


@end



