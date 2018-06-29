//
//  UserDefinePickerViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "UserDefinePickerViewController.h"
#import "CameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface UserDefinePickerViewController ()

@property (nonatomic, strong) CameraView *cameraView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *tokePhotoBtn;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSLayoutConstraint *topConatraint;
@property (nonatomic, strong) NSLayoutConstraint *leftConatraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConatraint;
@property (nonatomic, strong) NSLayoutConstraint *botomConatraint;

@end

@implementation UserDefinePickerViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addsubView];
    [self setNotification];
    
    [self addBtn];
    // Do any additional setup after loading the view.
}

- (void)addsubView {
    [self.view addSubview:self.cameraView];
    [self updateCameraViewConstrain];
    [self.view addSubview:self.imageView];
    self.imageView.frame = self.view.bounds;
    self.imageView.hidden = YES;
}

- (void)updateCameraViewConstrain {
//    if (self.topConatraint) {
//        [self.view removeConstraint:self.topConatraint];
//    }
//    if (self.leftConatraint) {
//        [self.view removeConstraint:self.leftConatraint];
//    }
//    if (self.rightConatraint) {
//        [self.view removeConstraint:self.rightConatraint];
//    }
//    if (self.botomConatraint) {
//        [self.view removeConstraint:self.botomConatraint];
//    }
//    self.topConatraint =   [NSLayoutConstraint constraintWithItem:self.cameraView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    self.leftConatraint =   [NSLayoutConstraint constraintWithItem:self.cameraView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    self.rightConatraint =   [NSLayoutConstraint constraintWithItem:self.cameraView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//    self.botomConatraint =   [NSLayoutConstraint constraintWithItem:self.cameraView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    [self.view addConstraints:@[self.topConatraint,self.leftConatraint,self.rightConatraint,self.botomConatraint]];
}

//横竖屏发生转动事件
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
   [self.view setNeedsLayout];
}


- (void)addBtn {
    self.closeBtn.frame = CGRectMake(10, self.view.frame.size.height - 30, 50, 30);
    self.tokePhotoBtn.frame = CGRectMake(60, self.view.frame.size.height - 30, 50, 30);

    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.tokePhotoBtn];
    
}


- (void)tokePhoto:(UIButton *)sender {
    [self.cameraView tokenPhotoComplete:^(id response) {
        [self.cameraView stopSession];
        self.imageView.hidden = NO;
        self.imageView.image = response;
    }];
}


-(void)closePhoto:(UIButton *)sender {
    [self popoverPresentationController];
}


- (void)rotateCameraView:(NSNotification *)sender {
   
    [self.cameraView rotatePreView];
}


// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait; // 或者其他值 balabala~
}
// 开启自动转屏
- (BOOL)shouldAutorotate {
    return YES;
}

/***
 //强制横竖屏方法
 - (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
 if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
 SEL selector = NSSelectorFromString(@"setOrientation:");
 NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
 [invocation setSelector:selector];
 [invocation setTarget:[UIDevice currentDevice]];
 int val = orientation;
 [invocation setArgument:&val atIndex:2];
 [invocation invoke];
 }
 }
 
 
 - (void)setInterfaceOrientation:(UIDeviceOrientation)orientation {
 if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
 [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
 }
 }


 */

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.cameraView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    
    
}

- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateCameraView:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)closeBtn:(UIButton *)sender {
    [self popoverPresentationController];
}

- (CameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraView alloc] initWithFrame:self.view.bounds];
        _cameraView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _cameraView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


- (UIButton *)tokePhotoBtn {
    if (!_tokePhotoBtn) {
        _tokePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tokePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [_tokePhotoBtn addTarget:self action:@selector(tokePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tokePhotoBtn;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
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
