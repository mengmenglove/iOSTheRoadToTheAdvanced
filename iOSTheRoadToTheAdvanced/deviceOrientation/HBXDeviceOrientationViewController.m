//
//  HBXDeviceOrientationViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/8/20.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HBXDeviceOrientationViewController.h"
#import "DeviceOrientation.h"

@interface HBXDeviceOrientationViewController ()<DeviceOrientationDelegate>

@property (nonatomic, strong) DeviceOrientation *origintation;

@property (nonatomic, strong) UILabel *textLabel;


@end

@implementation HBXDeviceOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.origintation = [[DeviceOrientation alloc] initWithDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel];    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.origintation startMonitor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.origintation stop];
}

- (void)directionChange:(TgDirection)direction {
    switch (direction) {
        case TgDirectionDown:
            self.textLabel.text = @"倒立竖屏";
            break;
        case TgDirectionleft:
            self.textLabel.text = @"横屏向左";
            break;
        case TgDirectionRight:
            self.textLabel.text = @"横屏向右";
            break;
        case TgDirectionPortrait:
            self.textLabel.text = @"竖屏直列";
            break;
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 200, self.view.frame.size.width, 100)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor blackColor];
    }
    return _textLabel;
}


@end
