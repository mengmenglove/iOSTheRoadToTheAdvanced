//
//  ImageChangeViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ImageChangeViewController.h"
#define  screen_width [UIScreen mainScreen].bounds.size.width
#define  screen_height [UIScreen mainScreen].bounds.size.height

@interface ImageChangeViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSArray *btnArray;

@property (nonatomic, strong) UIView *nagationBar;
@property (nonatomic, strong) UIView *toolBar;


@end

@implementation ImageChangeViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage ];
        CIFilter *filter = [CIFilter filterWithName:@"CIConvolution3X3"];
        [filter setValue:ciImage forKey: kCIInputImageKey];
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputBias"];
        CGFloat weights[] = {0,-1,0,
            -1,5,-1,
            0,-1,0};
        CIVector *inputWeights = [CIVector vectorWithValues:weights count:9];
        [filter setValue:inputWeights forKey:@"inputWeights"];
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outPutImage = filter.outputImage;
        CGImageRef newCIImage = [context createCGImage:outPutImage fromRect: outPutImage.extent];
        UIImage *resultImage = [UIImage imageWithCGImage:newCIImage scale:2.0 orientation:image.imageOrientation];
        CGImageRelease(newCIImage);
        self.image = resultImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)creatSubView {
    
    [self.view addSubview:self.imageView];
    self.imageView.frame = self.view.bounds;
    self.imageView.image = self.image;
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(20, 20, 40.f, 40.0f);
    [self.closeButton setImage:[UIImage imageNamed:@"abc_ic_clear_mtrl_alpha"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(cloesVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    
   
    
    
    
    
    
    
    
    
    
    
    self.btnArray = @[@"黑白",@"原色"];
    
    CGFloat originX = 10;
    CGFloat originY = 500;
    UIButton *btn;
    for(int i = 0 ; i < self.btnArray.count; i++){
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:self.btnArray[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(originX ,originY, 50, 50);
        [self.view addSubview:btn];
        originX += 60;
        if(screen_width - originX < 60)
        {
            originX = 10;
            originY = 500 + 60;
        }
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(photoChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}


- (void)photoChange:(UIButton *)sender {
    UIImage *image = nil;
    NSInteger type = sender.tag - 100 + 1;
    if (type == 1) {
    
        UIImage *image = nil;
        image = self.image;
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage ];
        
        
//        CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
//        [filter setValue:ciImage forKey: kCIInputImageKey];
//        [filter setValue:[CIColor colorWithRed:0.6 green:0.45 blue:0.31 alpha:1.0] forKey:kCIInputColorKey];
//        [filter setValue:@1.0 forKey:kCIInputIntensityKey];

        CIFilter *filter = [CIFilter filterWithName:@"CIColorPolynomial"];
        [filter setValue:ciImage forKey: kCIInputImageKey];
        [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:kCIInputColorKey];
        [filter setValue:@1.0 forKey:kCIInputIntensityKey];
        
        
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outPutImage = filter.outputImage;
        CGImageRef newCIImage = [context createCGImage:outPutImage fromRect: outPutImage.extent];
        UIImage *resultImage = [UIImage imageWithCGImage:newCIImage scale:2.0 orientation:self.image.imageOrientation];
        CGImageRelease(newCIImage);
        self.imageView.image = resultImage;

    }else if(type == 2) {        
        self.imageView.image = image;
    }
    
}

- (void)cloesVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
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
    }
    return _nagationBar;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
    }
    return _toolBar;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
