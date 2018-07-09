//
//  ZJTKImageView.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/4.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ZJTKImageView.h"

@interface ZJTKImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *showImageView;


@property (nonatomic, strong) UIImageView *clipView;
@property (nonatomic, strong) UIImageView *backView;



@end

@implementation ZJTKImageView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        self.clipImage = image;
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.showImageView];
        self.scrollView.frame = self.bounds;
        self.showImageView.frame = self.scrollView.bounds;
        self.showImageView.image = image;
        [self addSubview:self.backView];
        [self addSubview:self.clipView];
    }
    return self;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.showImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    //缩放前调用
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //正在缩放时调用
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.zoomScale = 1.0;
        _scrollView.bouncesZoom = YES;
    }
    return _scrollView;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}

- (UIImageView *)clipView {
    if (!_clipView) {
        _clipView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        _clipView.backgroundColor = [UIColor whiteColor];
//        UIImage *image = [self imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] Size:CGSizeMake(40, 40)];
//        _clipView.image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
    return _clipView;
}

- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *image = [self imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] Size:CGSizeMake(40, 40)];
        _backView.image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
    return _backView;
}

- (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size

{
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, [color CGColor]);
    CGContextFillRect(ref, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
