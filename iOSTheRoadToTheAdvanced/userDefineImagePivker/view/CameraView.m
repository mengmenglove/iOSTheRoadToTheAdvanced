//
//  CameraView.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "CameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraView ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preView;
@property (nonatomic, assign) int back;







@end

@implementation CameraView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self startSession:AVCaptureDevicePositionBack];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        [self startSession:AVCaptureDevicePositionBack];
        
    }
    return self;
}

- (void)stopSession {    
    dispatch_sync(dispatch_queue_create("aizongjie_sesstion", DISPATCH_QUEUE_SERIAL), ^{
        [self.session stopRunning];
        [self.preView removeFromSuperlayer];
        _session = nil;
        _input = nil;
        _imageOutPut = nil;
        _preView = nil;
        _device = nil;
    });
    
}




- (void)tokenPhotoComplete:(TokePhotoComplete)complete {
    
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeRight ) {
        NSLog(@"请横屏拍照");
        return;
    }
    
    if (self.imageOutPut) {
        CGSize size = self.frame.size;
        [self tokePhotoWithImageOutput:self.imageOutPut videoOrientation:(AVCaptureVideoOrientationLandscapeLeft | AVCaptureVideoOrientationLandscapeRight) position:self.device.position size:size complete:complete];
    }
}

- (void)tokePhotoWithImageOutput:(AVCaptureStillImageOutput *)stillImageOutput videoOrientation:(AVCaptureVideoOrientation)videoOrientation  position:(AVCaptureDevicePosition)position size:(CGSize)size complete:(TokePhotoComplete)complete{
    
    AVCaptureConnection *videoConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection) {
        videoConnection.videoOrientation = videoOrientation;
        
        [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
            
            if (imageDataSampleBuffer) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *capImage = [UIImage imageWithData:imageData];
                if (complete) {
                    complete(capImage);
                }
            }
        }];
    }
}


-(void)startSession:(int)position {
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    
    NSArray<AVCaptureDevice *> *array = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in array) {
        if (device.position == position) {
            self.device = device;
            break;
        }
    }
    NSError *error;
    if ([self.device hasFlash]) {
        [self.device lockForConfiguration:&error];
        self.device.flashMode = AVCaptureFlashModeAuto;
        [self.device unlockForConfiguration];
    }
    
    
    
    NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    if (self.input == nil) {
        NSLog(@"shengcheng input is nil");
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    self.imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutPut.outputSettings = outputSettings;
    
    
    [self.session addOutput:self.imageOutPut];
    
    
    
    dispatch_sync(dispatch_queue_create("aizongjie_sesstion", DISPATCH_QUEUE_SERIAL), ^{
        [self.session startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self creatPreView];
            [self rotatePreView];
        });
    });
    
}

- (void)creatPreView {
    self.preView = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.preView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preView.frame = [UIScreen mainScreen].bounds;
    [self.layer addSublayer:self.preView];
}


- (void)rotatePreView {
    if (!self.preView) {
        return;
    }
    self.preView.frame = [UIScreen mainScreen].bounds;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            self.preView.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.preView.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.preView.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationPortrait:
            self.preView.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationUnknown:
            break;
        default:
            break;
    }
}



@end
