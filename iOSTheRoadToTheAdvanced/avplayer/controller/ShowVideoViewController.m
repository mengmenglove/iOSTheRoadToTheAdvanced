//
//  ShowVideoViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/10/12.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "ShowVideoViewController.h"
#import "ZJAvPlayerView.h"
#import "LiveController.h"


@interface ShowVideoViewController ()<ZJAvPlayerViewDelegate>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) ZJAvPlayerView *playerView;
@property (nonatomic, strong) LiveController *controllerView;
@property (nonatomic, strong) UIView *videoView;
@end

@implementation ShowVideoViewController

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.videoView];

    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.view);
    }];
    
    [self.view addSubview:self.controllerView];
    
    [self.controllerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.view);
    }];
    _controllerView.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadVideo];
}

- (void)loadVideo {
    if (_url) {
        [self.playerView setFatherView:self.videoView rect:self.view.bounds];
        self.playerView.delegate = self;
        [self.playerView startPlayWithUrl:_url];
    }
}

/** 开始触摸slider */
- (void)onControlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider {
    [self.playerView pasuseVideo];
}
/** slider触摸中 */
- (void)onControlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider {
    
}
/** slider触摸结束 */
- (void)onControlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider {
    [self.playerView seeSildeTime:slider.value];   
    NSLog(@"progressSliderTouchEnded: %f",slider.value);
}

- (void)onControlView:(UIView *)controlView progressSliderTap:(CGFloat)value {
    NSLog(@"onControlView:  progressSliderTap %f",value);
    [self.playerView pasuseVideo];
    [self.playerView seeSildeTime:value];
}


- (void)ZJAvPlayerView:(ZJAvPlayerView *)player progress:(NSInteger)progress totle:(NSInteger)totle {

    
    CGFloat value = (CGFloat)progress/(CGFloat)totle;
    [self.controllerView playerCurrentTime:progress totalTime:totle sliderValue:value];
    
    
}
- (void)ZJAvPlayerView:(ZJAvPlayerView *)player status:(ZJAvPlayerViewPlayStatus)status  {
    
    
}



- (ZJAvPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZJAvPlayerView alloc] init];
    }
    return _playerView;
}
- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] init];
        
    }
    return _videoView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (LiveController *)controllerView {
    if (!_controllerView) {
        _controllerView = [[LiveController alloc] init];
    }
    return _controllerView;
}

@end
