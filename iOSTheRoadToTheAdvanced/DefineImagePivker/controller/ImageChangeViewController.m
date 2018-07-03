//
//  ImageChangeViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ImageChangeViewController.h"
#import "ViewUtils.h"
#define  screen_width [UIScreen mainScreen].bounds.size.width
#define  screen_height [UIScreen mainScreen].bounds.size.height
#import "ImageFilterUtil.h"
#import "TKImageView.h"
#import "ZJDrawTool.h"

@interface ImageChangeViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *dramView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UIView *nagationBar;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) TKImageView *tkImageView;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) ZJDrawTool *drawTool;

@property (nonatomic, assign) CGFloat drawWidth;

@property (nonatomic, strong) UIButton *backLastDrawBtn;



@end

@implementation ImageChangeViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image =  [ImageFilterUtil  grayHandlescale:image type:1];
        self.drawWidth = 5;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getBtnModel];
    [self creatSubView];
}

- (void)creatSubView {
    
    [self.view addSubview:self.imageView];
    self.imageView.frame = CGRectMake(0, 64, self.view.width - 100, self.view.height - 84);
    self.imageView.image = self.image;
    
    
    _tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width - 100, self.view.height - 84)];
    [self.view addSubview:_tkImageView];
    //需要进行裁剪的图片对象
    _tkImageView.toCropImage = _image;
    //是否显示中间线
    _tkImageView.showMidLines = YES;
    //是否需要支持缩放裁剪
    _tkImageView.needScaleCrop = YES;
    //是否显示九宫格交叉线
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 1;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 6;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 0.5;
    _tkImageView.initialScaleFactor = .8f;
    _tkImageView.cropAspectRatio = 0;
    _tkImageView.maskColor = [UIColor clearColor];
  
    
    [self.view addSubview:self.nagationBar];
    [self.view addSubview:self.toolBar];
    
    
    [self.nagationBar addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];
    
    
    [self.nagationBar addSubview:self.backBtn];
    self.backBtn.frame = CGRectMake(10, 0, 70, 44);
    
    CGFloat originX = 35;
    CGFloat originY = 10;
    UIButton *btn;
    for(int i = 0 ; i < self.btnArray.count; i++){
        ButtonModel *model = self.btnArray[i];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //btn.backgroundColor = [UIColor greenColor];
        if (model.title.length) {
            [btn setTitle:model.title forState:UIControlStateNormal];
        }else if(model.icon.length) {
             [btn setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        }
        btn.frame = CGRectMake(originX ,originY, 40, 40);
        [self.toolBar addSubview:btn];
        originY += 50;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(photoChange:) forControlEvents:UIControlEventTouchUpInside];
    }
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


- (void)backRootView {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)backLastDrawClick:(UIButton *)sender {
    [self.drawTool backToLastDraw];
}


- (void)updateViews:(BOOL)isCropView {
    if (isCropView) {
        UIImage *image = [self.tkImageView currentCroppedImage];
        self.tkImageView.hidden = YES;
        self.imageView.image = image;
        [self.nagationBar addSubview:self.backLastDrawBtn];
        self.backLastDrawBtn.frame = CGRectMake(self.nagationBar.width - 60, 10, 50, 35);
        [self updateImageContentBtn];
        [self updateBtnView];
        [self drawTool];
    }else {
        
        
        
    }
    
}

- (void)photoChange:(UIButton *)sender {
    UIImage *image = nil;
    NSInteger type = sender.tag - 100;
    
    ButtonModel *mode = self.btnArray[type];
    
    switch (mode.type) {
        case buttonActionTypeClose:
            [self dismissViewControllerAnimated:false completion:nil];
            break;
        case buttonActionTypeRemoveRed:
            break;
        case buttonActionTypeRemoveBlue:
            break;
        case buttonActionTypeReduceNoice:
            break;
        case buttonActionTypeColorSuccess: {
                [self updateViews:YES];
            }
            break;
        case buttonActionTypeDrawSuccess: {
           
        
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
    
    
//    if (type == 1) {
//
//        UIImage *image = nil;
//        image = self.image;
//        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage ];
//        CIFilter *filter = [CIFilter filterWithName:@"CIColorPolynomial"];
//        [filter setValue:ciImage forKey: kCIInputImageKey];
//        [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:kCIInputColorKey];
//        [filter setValue:@1.0 forKey:kCIInputIntensityKey];
//
//        CIContext *context = [CIContext contextWithOptions:nil];
//        CIImage *outPutImage = filter.outputImage;
//        CGImageRef newCIImage = [context createCGImage:outPutImage fromRect: outPutImage.extent];
//        UIImage *resultImage = [UIImage imageWithCGImage:newCIImage scale:2.0 orientation:self.image.imageOrientation];
//        CGImageRelease(newCIImage);
//        self.imageView.image = resultImage;
//
//    }else if(type == 2) {
//        self.imageView.image = image;
//    }
    
}

- (void)updateBtnView {
    [self.toolBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat originX = 35;
    CGFloat originY = 10;
    UIButton *btn;
    for(int i = 0 ; i < self.btnArray.count; i++){
        ButtonModel *model = self.btnArray[i];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //btn.backgroundColor = [UIColor greenColor];
        if (model.iconColor) {
            UIImage *norImage = [self GetImageWithColor:model.iconColor andHeight:model.btnSize];
            UIImage *selectedImage = [self GetImageWithColor:model.iconSelectedColor andHeight:model.btnSize];
            [btn setImage:norImage forState:UIControlStateNormal];
            [btn setImage:selectedImage forState:UIControlStateSelected];
            btn.layer.cornerRadius = model.btnSize.height/2;
            btn.layer.masksToBounds = YES;
        }else if (model.title.length) {
            [btn setTitle:model.title forState:UIControlStateNormal];
        }else if(model.icon.length) {
            [btn setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
        }
        btn.frame = CGRectMake(originX ,originY, 40, 40);
        [self.toolBar addSubview:btn];
        originY += 50;
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
    self.nagationBar.frame = CGRectMake(0, 0, self.view.width, 44);
    self.toolBar.frame = CGRectMake(self.view.width - 100, 44, 100, self.view.height);
    self.titleLabel.center = self.nagationBar.center;
}

- (NSArray *)getBtnModel {
    [self.btnArray removeAllObjects];
    
    ButtonModel *model  = [ButtonModel initWithTitle:@"" icon:@"abc_ic_clear_mtrl_alpha"];
    model.type = buttonActionTypeClose;
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
    model.btnSize = CGSizeMake(20, 20);
    model.iconColor = [UIColor whiteColor];
    model.iconSelectedColor = [UIColor orangeColor];
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@""];
    model.type = buttonActionTypeRemoveContentLarge;
    model.iconColor = [UIColor whiteColor];
    model.btnSize = CGSizeMake(30, 30);
    model.iconSelectedColor = [UIColor orangeColor];
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@"abc_ic_menu_selectall_mtrl_alpha"];
    model.type = buttonActionTypeRemoveContentRect;
    [self.btnArray addObject:model];
    
    model  = [ButtonModel initWithTitle:@"" icon:@"cg_confirm1"];
    model.type = buttonActionTypeDrawSuccess;
    [self.btnArray addObject:model];
  
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
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
        _imageView = [[UIImageView alloc] init];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        NSArray *titArray = @[@"黑白",@"彩色"];
        _segmentControl = [[UISegmentedControl alloc] initWithItems:titArray];
        _segmentControl.tintColor = [UIColor greenColor];
    }
    return _segmentControl;
}

- (ZJDrawTool *)drawTool {
    if (!_drawTool) {
        [self.view addSubview:self.dramView];
        self.dramView.frame = CGRectMake(0, 64, self.view.width - 100, self.view.height - 84);
        _drawTool = [[ZJDrawTool alloc] initWithDrawView:self.dramView];
        _drawTool.type = DrawTypeLine;
        _drawTool.pathWidth = self.drawWidth;
    }
    return _drawTool;
}

- (UIImageView *)dramView {
    if (!_dramView) {
        _dramView = [[UIImageView alloc] init];
    }
    return _dramView;
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

@end



@implementation ButtonModel

+ (ButtonModel *)initWithTitle:(NSString *)title icon:(NSString *)icon {
    ButtonModel *model = [[ButtonModel alloc] init];
    model.title = title;
    model.icon = icon;
    return model;
}

@end

