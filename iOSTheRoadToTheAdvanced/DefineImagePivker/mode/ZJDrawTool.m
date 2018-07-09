//
//  ZJDrawTool.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ZJDrawTool.h"
#import "ViewUtils.h"


@interface ZJDrawPath()

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;

@end


@implementation ZJDrawPath

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth {
   
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = pathWidth;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    
    ZJDrawPath *path   = [[ZJDrawPath alloc] init];
    path.type = DrawTypeLine;
    path.beginPoint = beginPoint;
    path.pathWidth  = pathWidth;
    path.bezierPath = bezierPath;
    path.shape      = shapeLayer;
    return path;
}

+ (instancetype)pathToRect:(CGRect)rect {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    ZJDrawPath *path   = [[ZJDrawPath alloc] init];
    path.type = DrawTypeRectView;
    path.pathWidth  = 1;
    path.bezierPath = bezierPath;
    return path;
    
}

//曲线
- (void)pathLineToPoint:(CGPoint)movePoint;
{
    [self.bezierPath addLineToPoint:movePoint];
    self.shape.path = self.bezierPath.CGPath;
   
}

- (void)drawPath {
    if (self.type == DrawTypeRectView) {
        [[UIColor whiteColor] setFill];
        [[UIColor whiteColor] setStroke];
        [self.bezierPath fill];
        [self.bezierPath stroke];
    }else {
        [self.pathColor set];
        [self.bezierPath stroke];
    }
}

@end





@interface ZJDrawTool() <UIGestureRecognizerDelegate>
{
    UIImageView *_drawView;
    CGSize _originalImageSize;
    
    CGPoint startPoint;
    CGPoint changePoint;

    
    
}
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIView *rectangleView;

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@property (nonatomic, strong) NSHashTable *gestureTable;

@end


@implementation ZJDrawTool

- (instancetype)initWithDrawView:(UIImageView *)imageView {
    if (self = [super init]) {
        _drawView = imageView;
        _allPathArray = [NSMutableArray new];
        _gestureTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:2];
        [self setUp];
        
    }
    return self;
}

- (void)backToLastDraw {
 
    [_allPathArray removeLastObject];
    [self drawLine];
}
//draw
- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawView];
    if(sender.state == UIGestureRecognizerStateBegan) {
        startPoint = currentDraggingPosition;
        if (self.type == DrawTypeLine) {
            // 初始化一个UIBezierPath对象, 把起始点存储到UIBezierPath对象中, 用来存储所有的轨迹点
            ZJDrawPath *path = [ZJDrawPath pathToPoint:currentDraggingPosition pathWidth:MAX(1, self.pathWidth)];
            path.pathColor         = [UIColor orangeColor];
            path.shape.strokeColor = [UIColor whiteColor].CGColor;
            [_allPathArray addObject:path];
        }else {
            self.rectangleView.alpha = 1.0;
        }
    }
    
    if(sender.state == UIGestureRecognizerStateChanged) {
        changePoint = currentDraggingPosition;
        if (self.type == DrawTypeLine) {
            // 获得数组中的最后一个UIBezierPath对象(因为我们每次都把UIBezierPath存入到数组最后一个,因此获取时也取最后一个)
            ZJDrawPath *path = [_allPathArray lastObject];
            [path pathLineToPoint:currentDraggingPosition];//添加点
            [self drawLine];
        }else {
             [self updateRectangleViewFrame];
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.type == DrawTypeLine) {
            ZJDrawPath *path = [_allPathArray lastObject];
            path.pathColor = [UIColor whiteColor];
             [self drawLine];
        }
        
        if (self.type == DrawTypeRectView) {
            CGRect viewFrame = CGRectMake(startPoint.x < changePoint.x ? startPoint.x : changePoint.x,
                                          startPoint.y < changePoint.y ? startPoint.y : changePoint.y,
                                          startPoint.x < changePoint.x ? changePoint.x - startPoint.x : startPoint.x - changePoint.x,
                                          startPoint.y < changePoint.y ? changePoint.y - startPoint.y : startPoint.y - changePoint.y);
            ZJDrawPath *path = [ZJDrawPath pathToRect:viewFrame];
            path.pathColor         = [UIColor redColor];
            path.shape.strokeColor = [UIColor greenColor].CGColor;
             [_allPathArray addObject:path];
            [self drawLine];
        }
        self.rectangleView.alpha = 0.0;
    }
}

- (void)updateRectangleViewFrame {
    
    CGRect viewFrame = CGRectMake(startPoint.x < changePoint.x ? startPoint.x : changePoint.x,
                                  startPoint.y < changePoint.y ? startPoint.y : changePoint.y,
                                  startPoint.x < changePoint.x ? changePoint.x - startPoint.x : startPoint.x - changePoint.x,
                                  startPoint.y < changePoint.y ? changePoint.y - startPoint.y : startPoint.y - changePoint.y);
    self.rectangleView.frame = viewFrame;
    self.rectangleView.layer.borderWidth = 1;
    self.rectangleView.layer.borderColor = [[UIColor orangeColor] CGColor];
}

- (void)drawLine {
    CGSize size = _drawView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //去掉锯齿
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    for (ZJDrawPath *path in _allPathArray) {
        [path drawPath];
    }
    _drawView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)setUp {
    
    _originalImageSize = _drawView.image.size;
    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
        self.panGesture.maximumNumberOfTouches = 1;
        self.panGesture.delegate = self;
    }
    if (!self.panGesture.isEnabled) {
        self.panGesture.enabled = YES;
    }
   
    [_drawView addGestureRecognizer:self.panGesture];
    
    _drawView.userInteractionEnabled = YES;
    _drawView.layer.shouldRasterize = YES;
    _drawView.layer.minificationFilter = kCAFilterTrilinear;
    
}


- (void)cleanup {
    _drawView.userInteractionEnabled = NO;
    self.panGesture.enabled = NO;
}

// 是否允许开始触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}



- (UIView *)rectangleView {
    if (!_rectangleView) {
        _rectangleView = [[UIView alloc] init];
        [_drawView addSubview:_rectangleView];
    }
    return _rectangleView;
}

// 是否允许接收手指的触摸点
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![self.gestureTable containsObject:gestureRecognizer]) {
        [self.gestureTable addObject:gestureRecognizer];
        if (self.gestureTable.count >= 2) {
            UIPanGestureRecognizer *textToolPan = nil;
            UIPanGestureRecognizer *drawToolPan = nil;
            
            for (UIPanGestureRecognizer *pan in self.gestureTable) {
                if ([pan.view isKindOfClass:[UIImageView class]]) {
                    drawToolPan = pan;
                }
            }
            if (textToolPan && drawToolPan) {
                [drawToolPan requireGestureRecognizerToFail:textToolPan];
            }
        }
    }
    return YES;
}


@end





