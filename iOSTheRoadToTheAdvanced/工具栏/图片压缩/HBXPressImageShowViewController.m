//
//  HBXPressImageShowViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/12/7.
//  Copyright © 2018 黄保贤. All rights reserved.
//

#import "HBXPressImageShowViewController.h"

@interface HBXPressImageShowViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation HBXPressImageShowViewController

- (instancetype)initWithArray:(NSArray <UIImage *> *)images {
    if (self = [super init]) {
        _imageArray = images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    [self creatSubView];
    // Do any additional setup after loading the view.
}

- (void)creatSubView {
    
    if (_imageArray && _imageArray.count) {
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * _imageArray.count, self.view.frame.size.height);
        for (int i = 0; i < _imageArray.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.image = _imageArray[i];
            NSLog(@"imageSize: %@",NSStringFromCGSize(imageView.image.size));
            NSData *data = UIImageJPEGRepresentation(_imageArray[i], 0.6);
            NSLog(@"data.length : %lu",(unsigned long)data.length);
            imageView.image = [UIImage imageWithData:data];
            [_scrollView addSubview:imageView];
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, 40, 40, 40);
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
