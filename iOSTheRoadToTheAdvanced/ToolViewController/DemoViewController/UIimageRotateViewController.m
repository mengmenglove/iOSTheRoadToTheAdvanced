//
//  UIimageRotateViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "UIimageRotateViewController.h"
#import "ImageUtil.h"

@interface UIimageRotateViewController ()

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UIImage  *image;


@property (nonatomic, strong) NSTimer  *timer;

@end

@implementation UIimageRotateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.imageView];
    [self.imageView setFrame:CGRectMake(100, 100, 150, 150)];
    
    UIImage *image = [UIImage imageNamed:@"5.jpg"];
    self.image = image;
    self.imageView.image = image;
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [_timer fire];
    
    
    // Do any additional setup after loading the view.
}

- (void)onTimer {
    CGFloat bear =  rand() % 360;
    // 图片旋转代码
    self.imageView.image = [ImageUtil rotateRightWithImage:self.image degree: bear - 180];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
