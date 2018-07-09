//
//  ImageChangeViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

//#ifdef __cplusplus
//
//#import <opencv2/opencv.hpp>
//#import <opencv2/imgproc/types_c.h>
//#import <opencv2/imgcodecs/ios.h>
//#endif

#import "ImageChangeViewController.h"
#import "ViewUtils.h"
#define  screen_width [UIScreen mainScreen].bounds.size.width
#define  screen_height [UIScreen mainScreen].bounds.size.height
#import "ImageFilterUtil.h"
#import "ZJDrawTool.h"
#import "showSuccessImageViewController.h"
#import "UIImage+CropRotate.h"
#import "TOCropView.h"


#define KTITLESHOW_CLOP @"调整方框，裁剪题干"
#define KNAVAGATIONBARHEIGHT 44
#define KTOOLBARHEIGHT 70

#define KBTNWIDTH 35



@interface ImageChangeViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *dramView;
@property (nonatomic, strong) UIImageView *backGround;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UIView *nagationBar;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, strong) ZJDrawTool *drawTool;

@property (nonatomic, assign) CGFloat drawWidth;

@property (nonatomic, strong) UIButton *backLastDrawBtn;

@property (nonatomic, strong) UIImage *originImage;

@property (nonatomic, strong) TOCropView *cropView;

@property (nonatomic, assign) ImageEditType imageEditType;

@property (nonatomic, strong) UIScrollView *scrollView;



@end

@implementation ImageChangeViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.originImage = image;
        self.image = [self imageHandle:colorRangeNormal image:self.originImage];
        self.drawWidth = 5;
        self.imageEditType = ImageEditTypeColor;
    }
    return self;
}

- (UIImage *)imageHandle:(int)param image:(UIImage *)image {
//    cv::Mat cvImage1;
//    cv::Mat cvImage2;
//    cv::Mat cvImage3;
//    cv::Mat cvImage4;
//    cv::Mat cvImage5;
//    UIImageToMat(image, cvImage1);
//    // 将图像转换为灰度显示
//    cv::cvtColor(cvImage1,cvImage2,CV_RGB2GRAY);
//    cv::bilateralFilter(cvImage2, cvImage3, param, param * 2, param/2);
//    cv::adaptiveThreshold(cvImage3, cvImage4, 255.0, 0, 0, 25, 10);
    return  nil;//MatToUIImage(cvImage4);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getBtnModel];
    [self creatSubView];
    
   

}

- (void)creatSubView {
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.backGround];
    
    [self.backGround addSubview:self.imageView];
    [self.backGround addSubview:self.dramView];
    
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.image = self.image;
    
    
    [self.view addSubview:self.cropView];
    self.cropView.frame = CGRectMake(0, KNAVAGATIONBARHEIGHT,
                                     self.view.width - KTOOLBARHEIGHT,
                                     self.view.height - KNAVAGATIONBARHEIGHT);
    [self.cropView setAngle:1];

    [self.view addSubview:self.nagationBar];
    [self.view addSubview:self.toolBar];
    
    
    [self.nagationBar addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];
    
    
    [self.nagationBar addSubview:self.backBtn];
    self.backBtn.frame = CGRectMake(10, 0, 70, 44);
    
    CGFloat originX = (KTOOLBARHEIGHT - KBTNWIDTH - 5)/2 + 5;
    CGFloat originY = 10;
    UIButton *btn;
    for(int i = 0 ; i < self.btnArray.count; i++){
        ButtonModel *model = self.btnArray[i];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (model.title.length) {
            [btn setTitle:model.title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];

        }else if(model.icon.length) {
             [btn setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.frame = CGRectMake(originX ,originY, KBTNWIDTH, KBTNWIDTH);
        [self.toolBar addSubview:btn];
        originY += (KBTNWIDTH + 5);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(photoChange:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)updateCropImage:(UIImage *)image {
        [_cropView removeFromSuperview];
        _cropView = nil;
        self.image = image;
        [self.view addSubview:self.cropView];
        self.cropView.frame = CGRectMake(0, KNAVAGATIONBARHEIGHT,
                                         self.view.width - KTOOLBARHEIGHT,
                                         self.view.height - KNAVAGATIONBARHEIGHT);
        [self.cropView setAngle:1];
    
}




- (void)backRootView {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)backLastDrawClick:(UIButton *)sender {
    [self.drawTool backToLastDraw];
}


- (void)updateViews:(BOOL)isCropView {
    if (isCropView) {
        CGRect cropFrame = self.cropView.imageCropFrame;
        NSInteger angle = self.cropView.angle;
        UIImage * image = [self.image croppedImageWithFrame:cropFrame angle:angle circularClip:NO];
        self.image = image;
        self.imageView.image = self.image;
        [_cropView removeFromSuperview];
        _cropView = nil;
        [self.nagationBar addSubview:self.backLastDrawBtn];
        self.backLastDrawBtn.frame = CGRectMake(self.nagationBar.width - KBTNWIDTH - 10, 10, KBTNWIDTH, KBTNWIDTH);
        [self updateImageContentBtn];
        [self updateBtnView];
        [self refreshImageView];
        
    }else {
                        
    }
    
}

- (void)photoChange:(UIButton *)sender {
    NSInteger type = sender.tag - 100;
    for (UIButton *btn in [self.toolBar subviews]) {
        if ([btn isEqual:sender]) {
            btn.selected = YES;
        }else {
            btn.selected = NO;
        }
    }
    
    ButtonModel *mode = self.btnArray[type];
    
    switch (mode.type) {
        case buttonActionTypeClose: {
                if (self.imageEditType == ImageEditTypeColor) {
                    [self dismissViewControllerAnimated:false completion:nil];
                }else {
                    
                    self.scrollView.contentSize = self.scrollView.frame.size;
                    self.imageView.frame = self.scrollView.bounds;
                    self.dramView.frame = self.scrollView.bounds;
                    self.titleLabel.text = @"调整方框，裁剪题干";
                    self.imageEditType = ImageEditTypeElement;
                    [self.backLastDrawBtn removeFromSuperview];
                    [self getBtnModel];
                    [self updateBtnView];
                    [self updateCropImage:[self imageHandle:colorRangeNormal image:self.originImage]];
                }
            }
            break;
        case buttonActionTypeOrigin:
            {
                [self updateCropImage:self.originImage];
            }
            break;
        case buttonActionTypeNormal:
            {
                [self updateCropImage:[self imageHandle:colorRangeNormal image:self.originImage]];
            }
            break;
        case buttonActionTypeRemoveRed:
            {
                UIImage *newImage = [ImageFilterUtil removeRedGreen:self.originImage];
                newImage = [self imageHandle:colorRangeNoRedGreen image:newImage];
                [self updateCropImage:newImage];
            }
            break;
        case buttonActionTypeRemoveBlue:
            {
                UIImage *newImage = [ImageFilterUtil removeRedGreen:self.originImage];
                newImage = [self imageHandle:colorRangeNoRedGreen image:newImage];
                [self updateCropImage:newImage];
            }
            break;
        case buttonActionTypeReduceNoice: {
                UIImage *newImage = [self imageHandle:colorRangeReleaseVoice image:self.originImage];
                [self updateCropImage:newImage];
            }
            break;
        case buttonActionTypeColorSuccess: {
                self.imageEditType = ImageEditTypeElement;
                [self updateViews:YES];
            }
            break;
        case buttonActionTypeDrawSuccess: {
            
            UIGraphicsBeginImageContextWithOptions(self.image.size, NO, self.imageView.image.scale);
            [self.imageView.image drawAtPoint: CGPointZero];
            [self.dramView.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
            UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            showSuccessImageViewController *vc = [[showSuccessImageViewController alloc] initWithImage:tmp];
            [self presentViewController:vc animated:YES completion:nil];
                                   
        }
            break;
        case buttonActionTypeRemoveContentSmall:
             {
                self.drawTool.type = DrawTypeLine;
                self.drawWidth = 10;
                self.drawTool.pathWidth = self.drawWidth;
             }
            break;
        case buttonActionTypeRemoveContentMid:
            {
                self.drawTool.type = DrawTypeLine;
                self.drawWidth = 20;
                self.drawTool.pathWidth = self.drawWidth;
            }
            break;
        case buttonActionTypeRemoveContentLarge:
                {
                    self.drawTool.type = DrawTypeLine;
                    self.drawWidth = 30;
                    self.drawTool.pathWidth = self.drawWidth;
                }
            break;
        case buttonActionTypeRemoveContentRect:
            self.drawTool.type = DrawTypeRectView;
            break;
        default:
            break;
    }
}

- (void)updateBtnView {
    [self.toolBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat originX = (KTOOLBARHEIGHT - KBTNWIDTH - 5)/2 + 5;
    CGFloat originY = 10;
    UIButton *btn;
    for(int i = 0 ; i < self.btnArray.count; i++){
        ButtonModel *model = self.btnArray[i];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (model.iconColor) {
            UIImage *norImage = [self GetImageWithColor:model.iconColor andHeight:model.btnSize];
            UIImage *selectedImage = [self GetImageWithColor:model.iconSelectedColor andHeight:model.btnSize];
            [btn setImage:norImage forState:UIControlStateNormal];
            [btn setImage:selectedImage forState:UIControlStateSelected];
            btn.layer.cornerRadius = model.btnSize.height/2;
            btn.layer.masksToBounds = YES;
        }else if (model.title.length) {
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:model.title forState:UIControlStateNormal];
        }else if(model.icon.length) {
            [btn setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.frame = CGRectMake(originX ,originY, KBTNWIDTH, KBTNWIDTH);
        [self.toolBar addSubview:btn];
        originY += (KBTNWIDTH + 5);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(photoChange:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)cloesVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.nagationBar.frame = CGRectMake(0, 0, self.view.width, KNAVAGATIONBARHEIGHT);
    self.toolBar.frame = CGRectMake(self.view.width - KTOOLBARHEIGHT,
                                    KNAVAGATIONBARHEIGHT,
                                    KTOOLBARHEIGHT,
                                    self.view.height);
    self.titleLabel.center = self.nagationBar.center;
    
}

- (NSArray *)getBtnModel {
    [self.btnArray removeAllObjects];
    
    ButtonModel *model  = [ButtonModel initWithTitle:@"" icon:@"abc_ic_clear_mtrl_alpha"];
    model.type = buttonActionTypeClose;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"彩色" icon:@""];
    model.type = buttonActionTypeOrigin;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"标准" icon:@""];
    model.type = buttonActionTypeNormal;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"去红" icon:@""];
    model.type = buttonActionTypeRemoveRed;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"去蓝" icon:@""];
    model.type = buttonActionTypeRemoveBlue;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"去燥" icon:@""];
    model.type = buttonActionTypeReduceNoice;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@"cg_confirm1"];
    model.type = buttonActionTypeColorSuccess;
    [self.btnArray addObject:model];
    return self.btnArray;
}

- (void)updateImageContentBtn {
    
    [self.btnArray removeAllObjects];
    
    ButtonModel *model  = [ButtonModel initWithTitle:@"" icon:@"abc_ic_clear_mtrl_alpha"];
    model.type = buttonActionTypeClose;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@""];
    model.type = buttonActionTypeRemoveContentSmall;
    model.btnSize = CGSizeMake(10, 10);
    model.iconColor = [UIColor whiteColor];
    model.iconSelectedColor = [UIColor orangeColor];
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@""];
    model.type = buttonActionTypeRemoveContentMid;
    model.btnSize = CGSizeMake(15, 15);
    model.iconColor = [UIColor whiteColor];
    model.iconSelectedColor = [UIColor orangeColor];
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@""];
    model.type = buttonActionTypeRemoveContentLarge;
    model.iconColor = [UIColor whiteColor];
    model.btnSize = CGSizeMake(20, 20);
    model.iconSelectedColor = [UIColor orangeColor];
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@"abc_ic_menu_selectall_mtrl_alpha"];
    model.type = buttonActionTypeRemoveContentRect;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@"cg_confirm1"];
    model.type = buttonActionTypeDrawSuccess;
    [self.btnArray addObject:model];
  
}


#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.backGround;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{ }

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark- Orientations

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}


- (void)refreshImageView {
    if (self.imageView.image == nil) {
        self.imageView.image = self.image;
    }
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
    [self viewDidLayoutSubviews];
}

- (void)resetImageViewFrame {
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 ) {
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 3);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}



- (UIView *)nagationBar {
    if (!_nagationBar) {
        _nagationBar = [[UIView alloc] init];
        _nagationBar.backgroundColor = [UIColor blackColor];
    }
    return _nagationBar;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor blackColor];
    }
    return _toolBar;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.backGround.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backRootView) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"cg_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}


- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] init];;
    }
    return _btnArray;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.text = @"调整方框，裁剪题干";
    }
    return _titleLabel;
}

- (ZJDrawTool *)drawTool {
    if (!_drawTool) {
        _drawTool = [[ZJDrawTool alloc] initWithDrawView:self.dramView];
        _drawTool.type = DrawTypeLine;
        _drawTool.pathWidth = self.drawWidth;
    }
    return _drawTool;
}

- (UIImageView *)dramView {
    if (!_dramView) {
        _dramView = [[UIImageView alloc] initWithFrame:self.backGround.bounds];
        _dramView.contentMode = UIViewContentModeCenter;
        _dramView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        _dramView.userInteractionEnabled = YES;
    }
    return _dramView;
}

- (UIImageView *)backGround {
    if (!_backGround) {
        _backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                    self.view.width - KTOOLBARHEIGHT,
                                                                    self.view.height - KNAVAGATIONBARHEIGHT)];
        _backGround.userInteractionEnabled = YES;
        
    }
    return _backGround;
}




- (UIButton *)backLastDrawBtn {
    if (!_backLastDrawBtn) {
        _backLastDrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backLastDrawBtn setImage:[UIImage imageNamed:@"cg_undo"] forState:UIControlStateNormal];
        [_backLastDrawBtn addTarget:self action:@selector(backLastDrawClick:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _backLastDrawBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, KNAVAGATIONBARHEIGHT,
                                                                     self.view.width - KTOOLBARHEIGHT,
                                                                     self.view.height - KNAVAGATIONBARHEIGHT)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = NO;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.contentSize = _scrollView.bounds.size;
        _scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
        _scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
        _scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
        
    }
    return _scrollView;
}

- (TOCropView *)cropView {
    if (!_cropView) {
        _cropView = [[TOCropView alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault
                                                        image:self.image];
       
        _cropView.frame = CGRectMake(0, KNAVAGATIONBARHEIGHT,
                                     self.view.width - KTOOLBARHEIGHT,
                                     self.view.height - KNAVAGATIONBARHEIGHT);
        _cropView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _cropView;
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGSize)size
{
    CGRect r= CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end



@implementation ButtonModel

+ (ButtonModel *)initWithTitle:(NSString *)title icon:(NSString *)icon {
    ButtonModel *model = [[ButtonModel alloc] init];
    model.title = title;
    model.icon = icon;
    return model;
}

@end

