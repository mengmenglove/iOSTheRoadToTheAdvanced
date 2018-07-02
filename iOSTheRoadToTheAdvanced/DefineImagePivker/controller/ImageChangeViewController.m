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

@interface ImageChangeViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UIView *nagationBar;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;




@end

@implementation ImageChangeViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image =  [ImageFilterUtil  grayHandlescale:image type:1];;
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
    self.imageView.frame = self.view.bounds;
    self.imageView.image = self.image;
//    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.closeButton.frame = CGRectMake(20, 20, 40.f, 40.0f);
//    [self.closeButton setImage:[UIImage imageNamed:@"abc_ic_clear_mtrl_alpha"] forState:UIControlStateNormal];
//    [self.closeButton addTarget:self action:@selector(cloesVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.closeButton];
    
    
    [self.view addSubview:self.nagationBar];
    [self.view addSubview:self.toolBar];
    
    [self.nagationBar addSubview:self.backBtn];
    self.backBtn.frame = CGRectMake(10, 0, 70, 44);
    
    CGFloat originX = 25;
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
        btn.frame = CGRectMake(originX ,originY, 50, 50);
        [self.toolBar addSubview:btn];
        originY += 60;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(photoChange:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)backRootView {
    [self dismissViewControllerAnimated:false completion:nil];
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
        case buttonActionTypeSuccess:
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
    model.type = buttonActionTypeSuccess;
    [self.btnArray addObject:model];
    
    
    return self.btnArray;
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

@end



@implementation ButtonModel

+ (ButtonModel *)initWithTitle:(NSString *)title icon:(NSString *)icon {
    ButtonModel *model = [[ButtonModel alloc] init];
    model.title = title;
    model.icon = icon;
    return model;
}

@end

