//
//  showSuccessImageViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/4.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "showSuccessImageViewController.h"
#import "ViewUtils.h"

@interface showSuccessImageViewController ()

@property (nonatomic, strong) UIImage *imgae;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation showSuccessImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.imgae = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    self.imageView.size = CGSizeMake(400, 400) ;
    self.imageView.image = self.imgae;
    self.imageView.center = self.view.center;
    
    [self.view addSubview:self.backBtn];
    self.backBtn.frame = CGRectMake(10, 10, 50, 50);
    
    // Do any additional setup after loading the view.
}

- (void)backRootView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
