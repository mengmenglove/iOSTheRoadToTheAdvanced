//
//  HBXCacheVideoController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/20.
//  Copyright © 2019 黄保贤. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "APLPlayerView.h"
#import "APLCustomAVARLDelegate.h"
#import "HBXCacheVideoController.h"
#import "LiveController.h"

/* Asset keys */
NSString * const kPlayableKey        = @"playable";

/* PlayerItem keys */
NSString * const kStatusKey         = @"status";

/* AVPlayer keys */
NSString * const kRateKey            = @"rate";
NSString * const kCurrentItemKey    = @"currentItem";

static void *AVARLDelegateDemoViewControllerRateObservationContext = &AVARLDelegateDemoViewControllerRateObservationContext;
static void *AVARLDelegateDemoViewControllerStatusObservationContext = &AVARLDelegateDemoViewControllerStatusObservationContext;
static void *AVARLDelegateDemoViewControllerCurrentItemObservationContext = &AVARLDelegateDemoViewControllerCurrentItemObservationContext;





@interface HBXCacheVideoController ()
{
    BOOL seekToZeroBeforePlay;
    APLCustomAVARLDelegate *delegate;
    
}
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) APLPlayerView *playView;
@property (nonatomic, copy) NSURL* URL;
@property (readwrite, retain, setter=setPlayer:, getter=player) AVPlayer* player;
@property (retain) AVPlayerItem* playerItem;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *videoContainer;
@property (nonatomic, strong) UIView *actionContainer;
@property (nonatomic, strong) LiveController *controllerView;
@end

@implementation HBXCacheVideoController

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.container];
    [self.container addSubview:self.videoContainer];
    [self.container addSubview:self.actionContainer];
    
    self.container.frame = self.view.bounds;
    self.videoContainer.frame = self.view.bounds;
    self.actionContainer.frame = self.view.bounds;
    
    [self.videoContainer addSubview:self.playView];
    self.playView.frame = self.view.bounds;        
    // Do any additional setup after loading the view.
}


- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.userInteractionEnabled = YES;
    }
    return _container;
}

- (UIView *)videoContainer {
    if (!_videoContainer) {
        _videoContainer = [[UIView alloc] init];
        
    }
    return _videoContainer;
}

- (UIView *)actionContainer {
    if (!_actionContainer) {
        _actionContainer = [[UIView alloc] init];
        _actionContainer.userInteractionEnabled = YES;
    }
    return _actionContainer;
}

- (APLPlayerView *)playView {
    if (!_playView) {
        _playView = [[APLPlayerView alloc] init];
    }
    return _playView;
}
- (LiveController *)controllerView {
    if (!_controllerView) {
        _controllerView = [[LiveController alloc] init];
    }
    return _controllerView;
}


@end
