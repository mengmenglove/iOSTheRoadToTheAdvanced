//
//  ZJAvplayerViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/3/20.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "ZJAvplayerViewController.h"
#import <AVFoundation/AVFoundation.h>

//http://1400165595.vod2.myqcloud.com/fadf8fc6vodcq1400165595/517e330b5285890784105772341/playlist.f9.mp4


@interface ZJAvplayerViewController ()
{
    BOOL _played;
    NSString *_totalTime;
    NSDateFormatter *_dateFormatter;
    CGFloat rate;
}

@property (nonatomic, strong) AVPlayerLayer *layer;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) UIButton *rateButton;
@property (nonatomic, strong) UIButton *seekButton;
@property (nonatomic, assign) NSInteger totleTiem;



@end

@implementation ZJAvplayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.maskView];
    
    rate = 1.0;
    
    self.maskView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width/16*9);
    
    NSString *urlStr = @"http://1400165595.vod2.myqcloud.com/fadf8fc6vodcq1400165595/517e330b5285890784105772341/playlist.f9.mp4";
    
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
//    [playerItem addObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>]
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    
    
    _avPlayer = [[AVPlayer alloc] initWithPlayerItem: self.playerItem];
    
    _layer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    
    _layer.backgroundColor = [[UIColor greenColor] CGColor];
    
    _layer.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width/16*9);
    
    [self.maskView.layer addSublayer:_layer];
    
    [_avPlayer play];
    
    
//    [_avPlayer setRate:1.0];
    
    [self.view addSubview:self.rateButton];
    
    [self.view addSubview:self.seekButton];
    
    self.rateButton.frame = CGRectMake(10, 400 , self.view.frame.size.width - 20, 40);
    
    self.seekButton.frame = CGRectMake(10, 600, self.view.frame.size.width - 20, 40);
    
    // Do any additional setup after loading the view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
//            self.stateButton.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
//            [self customVideoSlider:duration];// 自定义UISlider外观
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
//            [self monitoringPlayback:self.playerItem];// 监听播放状态
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        
        NSLog(@"current:%lld timescale:%d  %lld", self.playerItem.currentTime.value, self.playerItem.currentTime.timescale, self.playerItem.currentTime.value/self.playerItem.currentTime.timescale);
//        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
//        NSLog(@"current: %f current:%f totle:%f", timeInterval/totalDuration, timeInterval, totalDuration);
        
//        [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
    }
}



- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void)rateButtonClick:(UIButton *)sender {
    
    rate += 0.5;
    if (rate>3) {
        rate = 0.5;
    }
    NSLog(@"rate: %f",rate);
    [self.avPlayer setRate:rate];
}

- (void)seekButtonClick:(UIButton *)sender {
    [self.avPlayer pause];
    
    CMTime time = self.playerItem.currentTime;
    
    CMTime time1 = CMTimeMake(time.timescale * 200, time.timescale);
    
    NSLog(@"%lld  %d", time.value, time.timescale);
    
    CMTime newTime = CMTimeAdd(time, time1);
    
   
    [self.avPlayer seekToTime:newTime];
    [self.avPlayer play];
    
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
    }
    return _maskView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)rateButton {
    if (!_rateButton) {
        _rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rateButton setTitle:@"倍数修改,每次加0.5,到3变成0.5" forState:UIControlStateNormal];
        [_rateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rateButton addTarget:self action:@selector(rateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rateButton;
}

- (UIButton *)seekButton {
    if (!_seekButton) {
        _seekButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seekButton setTitle:@"每次seek一分钟" forState:UIControlStateNormal];
        [_seekButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_seekButton addTarget:self action:@selector(seekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seekButton;
}


@end
