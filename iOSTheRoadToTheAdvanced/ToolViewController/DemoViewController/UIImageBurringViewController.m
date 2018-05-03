//
//  UIImageBurringViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "UIImageBurringViewController.h"
#import "ImageBlurring.h"

@interface UIImageBurringViewController ()

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UIImage  *image;

@end

@implementation UIImageBurringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.imageView];
    [self.imageView setFrame:CGRectMake(100, 100, 150, 150)];
    
    UIImage *image = [UIImage imageNamed:@"6.jpg"];
    self.image = image;
    self.imageView.image = [ImageBlurring gaussianBlurWithBias:5 valueImg:self.image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
