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
    path.beginPoint = beginPoint;
    path.pathWidth  = pathWidth;
    path.bezierPath = bezierPath;
    path.shape      = shapeLayer;
    return path;
}



//曲线
- (void)pathLineToPoint:(CGPoint)movePoint;
{
    //判断绘图类型
    [self.bezierPath addLineToPoint:movePoint];
    self.shape.path = self.bezierPath.CGPath;
}

- (void)addRect:(CGRect)rect {
    UIBezierPath *newBea = [UIBezierPath bezierPathWithRect:rect];
    
    [self.bezierPath appendPath:newBea];
}

- (void)drawPath {
    [self.pathColor set];
    [self.bezierPath stroke];
}

@end





@interface ZJDrawTool()
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


@end


@implementation ZJDrawTool

- (instancetype)initWithDrawView:(UIImageView *)imageView {
    if (self = [super init]) {
        _drawView = imageView;
        _allPathArray = [NSMutableArray new];
        [self setUp];
        
    }
    return self;
}

- (void)backToLastDraw {
    NSString *actionStr = [self.actionArray lastObject];
    if ([actionStr isEqualToString:@"2"]) {
        UIView *viwe = [self.allRectViewArray lastObject];
        [viwe removeFromSuperview];
        [self.allRectViewArray removeLastObject];
    }else {
         [_allPathArray removeLastObject];
         [self drawLine];
    }
    [self.actionArray lastObject];
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
            path.pathColor         = [UIColor whiteColor];
            path.shape.strokeColor = [UIColor whiteColor].CGColor;
            [_allPathArray addObject:path];
            [self.actionArray addObject:@"1"];
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
        
        if (self.type == DrawTypeRectView) {
            self.rectangleView.alpha = 0.0;
            [self addWhiteView];
        }
        
//        if (self.drawToolStatus) {
//            self.drawToolStatus(_allPathArray.count > 0 ? : NO);
//        }
//        if (self.drawingCallback) {
//            self.drawingCallback(NO);
//        }
    }
}

- (void)updateRectangleViewFrame {
    
    CGRect viewFrame = CGRectMake(startPoint.x < changePoint.x ? startPoint.x : changePoint.x,
                                  startPoint.y < changePoint.y ? startPoint.y : changePoint.y,
                                  startPoint.x < changePoint.x ? changePoint.x - startPoint.x : startPoint.x - changePoint.x,
                                  startPoint.y < changePoint.y ? changePoint.y - startPoint.y : startPoint.y - changePoint.y);
    self.rectangleView.frame = viewFrame;
}

- (void)addWhiteView {
    CGRect viewFrame = CGRectMake(startPoint.x < changePoint.x ? startPoint.x : changePoint.x,
                                  startPoint.y < changePoint.y ? startPoint.y : changePoint.y,
                                  startPoint.x < changePoint.x ? changePoint.x - startPoint.x : startPoint.x - changePoint.x,
                                  startPoint.y < changePoint.y ? changePoint.y - startPoint.y : startPoint.y - changePoint.y);
    UIView *view = [[UIView alloc] initWithFrame:viewFrame];
    view.backgroundColor = [UIColor whiteColor];
    [_drawView addSubview:view];
    [self.allRectViewArray addObject:view];
    [self.actionArray addObject:@"2"];
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

- (void)drawingViewDidTap:(UITapGestureRecognizer *)sender {
    
    
}


- (void)setUp {
    _originalImageSize = _drawView.image.size;
    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
//        self.panGesture.delegate = self;
        self.panGesture.maximumNumberOfTouches = 1;
    }
    if (!self.panGesture.isEnabled) {
        self.panGesture.enabled = YES;
    }
    //点击手势
    if (!self.tapGesture) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidTap:)];
//        self.tapGesture.delegate = [WBGImageEditorGestureManager instance];
        self.tapGesture.numberOfTouchesRequired = 1;
        self.tapGesture.numberOfTapsRequired = 1;
    }
    
    [_drawView addGestureRecognizer:self.panGesture];
    [_drawView addGestureRecognizer:self.tapGesture];
    
    _drawView.userInteractionEnabled = YES;
    _drawView.layer.shouldRasterize = YES;
    _drawView.layer.minificationFilter = kCAFilterTrilinear;
    
}

- (void)cleanup {
    _drawView.userInteractionEnabled = NO;
    self.panGesture.enabled = NO;
    
}


/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (NSMutableArray *)allRectViewArray {
    if (!_allRectViewArray) {
        _allRectViewArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _allRectViewArray;
}

- (NSMutableArray *)actionArray {
    if (!_actionArray) {
        _actionArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _actionArray;
}

- (UIView *)rectangleView {
    if (!_rectangleView) {
        _rectangleView = [[UIView alloc] init];
        _rectangleView.backgroundColor = [UIColor whiteColor];
        [_drawView addSubview:_rectangleView];
    }
    return _rectangleView;
}


@end





