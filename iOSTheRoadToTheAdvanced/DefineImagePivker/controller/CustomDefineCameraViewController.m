//
//  CustomDefineCameraViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "CustomDefineCameraViewController.h"
#import "SimpleCamera.h"
#import "ViewUtils.h"
#import "ImageChangeViewController.h"


#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width

#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height

#define VIEW_TOOLBARHEIGHT 100

@interface CustomDefineCameraViewController ()

@property (strong, nonatomic) SimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton *labiaryBtn;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) UIImageView *showOrientationsView;
@property (nonatomic, strong) UIImageView *orientationsView;

@end

@implementation CustomDefineCameraViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self addsubView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)addsubView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.camera = [[SimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                               position:LLCameraPositionRear
                                           videoEnabled:YES];
    
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.camera.fixOrientationAfterCapture = NO;
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(SimpleCamera *camera, AVCaptureDevice * device) {
        NSLog(@"Device changed.");
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(SimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        if([error.domain isEqualToString:SimpleCameraErrorDomain]) {
            if(error.code == SimpleCameraErrorCodeCameraPermission ||
               error.code == SimpleCameraErrorCodeMicrophonePermission) {
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    
    
    [self.view addSubview:self.toolBar];
    
   
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(20, 20, 40.f, 40.0f);
    [self.closeButton setImage:[UIImage imageNamed:@"abc_ic_clear_mtrl_alpha"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(cloesVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.closeButton];
    
    self.labiaryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.labiaryBtn.frame = CGRectMake(20, 20, 40.f, 40.0f);
    [self.labiaryBtn setImage:[UIImage imageNamed:@"cg_album"] forState:UIControlStateNormal];
    [self.labiaryBtn addTarget:self action:@selector(cloesVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.labiaryBtn];
    
    
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.flashButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.flashButton.tintColor = [UIColor whiteColor];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash.png"] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
//    if([SimpleCamera isFrontCameraAvailable] ) {
//        self.switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        self.switchButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 22.0f + 20.0f);
//        self.switchButton.tintColor = [UIColor whiteColor];
//        [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
//        self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
//        [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:self.switchButton];
//    }
    // Do any additional setup after loading the view.
    [self.view addSubview:self.showOrientationsView];
    [self.showOrientationsView addSubview:self.orientationsView];
    
}
- (void)viewOrientationChange {
    
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        self.showOrientationsView.alpha = 0.0;
    }else {
         self.showOrientationsView.alpha = 0.6;
    }
    
}


- (void)cloesVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)control
{
    NSLog(@"Segment value changed!");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button
{
    [self.camera togglePosition];
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)flashButtonPressed:(UIButton *)button
{
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        // capture
        [self.camera capture:^(SimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
            if(!error) {
                [camera stop];
                ImageChangeViewController *VC = [[ImageChangeViewController alloc] initWithImage:image];
                [weakSelf presentViewController:VC animated:NO completion:nil];
            }
            else {
                NSLog(@"An error has occured: %@", error);
            }
        } exactSeenImage:YES];
        
    } else {
        if(!self.camera.isRecording) {

            
        } else {
            self.segmentedControl.hidden = NO;
            self.flashButton.hidden = NO;
//            self.switchButton.hidden = NO;
            
            self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
            self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            
            [self.camera stopRecording];
        }
    }
}

/* other lifecycle methods */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.contentBounds;
    self.showOrientationsView.frame = self.view.contentBounds;
    self.orientationsView.center = self.showOrientationsView.center;
    
    
    self.flashButton.center = self.view.contentCenter;
    self.flashButton.top = 5.0f;
    
//    self.switchButton.top = 5.0f;
//    self.switchButton.right = self.view.width - 5.0f;
    
//    self.segmentedControl.left = 12.0f;
//    self.segmentedControl.bottom = self.view.height - 35.0f;
    
    
    CGFloat width = (VIEW_WIDTH > VIEW_HEIGHT) ? VIEW_WIDTH: VIEW_HEIGHT;
    CGFloat height = (VIEW_WIDTH > VIEW_HEIGHT) ? VIEW_HEIGHT: VIEW_WIDTH;
    self.toolBar.frame = CGRectMake(width - VIEW_TOOLBARHEIGHT, 0, VIEW_TOOLBARHEIGHT, height);
    
    self.closeButton.origin = CGPointMake((self.toolBar.width - 40)/2, 10);
    self.labiaryBtn.origin = CGPointMake((self.toolBar.width - 40)/2, self.toolBar.height - 60);
    self.snapButton.center = self.toolBar.contentCenter;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor blackColor];
    }
    return _toolBar;
}

-  (UIImageView *)showOrientationsView {
    if (!_showOrientationsView) {
        _showOrientationsView = [[UIImageView alloc] init];
        _showOrientationsView.backgroundColor = [UIColor blackColor];
        _showOrientationsView.alpha = 0.0;
//        _showOrientationsView.image = [UIImage imageNamed:@"cg_orientation"];
    }
    return _showOrientationsView;
}

- (UIImageView *)orientationsView {
    
    if (!_orientationsView) {
        _orientationsView = [[UIImageView alloc] init];
        _orientationsView.size = CGSizeMake(150, 150);
        _orientationsView.contentMode = UIViewContentModeScaleAspectFit;
        _orientationsView.image = [UIImage imageNamed:@"cg_orientation"];
    }
    return _orientationsView;
}


@end
