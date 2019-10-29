//
//  ZJAvPlayerView.m
//  aizongjie
//
//  Created by huangbaoxian on 2019/10/10.
//  Copyright © 2019 wennzg. All rights reserved.
//

#import "ZJAvPlayerView.h"

@interface ZJAvPlayerView ()
<AVAssetResourceLoaderDelegate>
{
    CGFloat totlePlayTime;
    
}
@property (nonatomic, strong) AVPlayerLayer *avLayer;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) CGRect fatherRect;
@property (nonatomic, strong) AVURLAsset *avAsset;
@property (nonatomic, strong) NSMutableArray *requestList;
@end


@implementation ZJAvPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)setFatherView:(UIView *)fatherView rect:(CGRect)rect {
    self.backgroundColor = [UIColor blackColor];
    NSLog(@"setFatherView: %@", NSStringFromCGRect(rect));
    self.fatherRect = rect;
    if (fatherView) {
        [fatherView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(fatherView);
        }];
    }else {
        [self removeFromSuperview];
    }
}


- (void)startPlayWithUrl:(NSString *)urlStr {
    totlePlayTime = 1.0;
    NSURL *url;
    if ([urlStr containsString:@"fileCache"]) {
        url = [NSURL fileURLWithPath:urlStr];        
    }else {
        url = [NSURL URLWithString:urlStr];
    }
    
    
    self.avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    [self.avAsset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    self.playerItem = [[AVPlayerItem alloc] initWithAsset:self.avAsset];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    _avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
    _avLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    
    _avLayer.backgroundColor = [[UIColor blackColor] CGColor];
    
    _avLayer.frame = self.fatherRect;
    
    [self.layer addSublayer:_avLayer];
    
    dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerMovieFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    WeakSelf
    [_avPlayer play];
}

- (void)pasuseVideo {
    [_avPlayer pause];
    
}
- (void)resumeVideo {
    [_avPlayer play];
}

- (void)seekTime:(NSInteger)progress {
    CGFloat time = progress;
    [self.avPlayer seekToTime:CMTimeMake(time/totlePlayTime, 1)];
}

- (void)seeSildeTime:(CGFloat)value {
    [self.avPlayer pause];
  
    WeakSelf
    [self.avPlayer seekToTime:CMTimeMake(totlePlayTime * value, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            [weakSelf.avPlayer play];
            NSLog(@"seek 成功");
        }else {
            NSLog(@"seek 失败");
        }
    }];
}

- (void)playerMovieFinish {
     [self.delegate ZJAvPlayerView:self status:ZJAvPlayerViewPlayStatusEnd];
}

- (void)stopVideo {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_avPlayer pause];
    _avPlayer = nil;
    [_avLayer removeFromSuperlayer];
    self.playerItem = nil;
    [self removeFromSuperview];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ZJAvPlayerView:status:)]) {
                [self.delegate ZJAvPlayerView:self status:ZJAvPlayerViewPlayStatusPrePlay];
            }
            NSLog(@"AVPlayerStatusReadyToPlay");
            //            self.stateButton.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            totlePlayTime = totalSecond;
//            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            NSLog(@"movie total duration:%f",totalSecond);
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            if (self.delegate && [self.delegate respondsToSelector:@selector(ZJAvPlayerView:status:)]) {
                [self.delegate ZJAvPlayerView:self status:ZJAvPlayerViewPlayStatusFailed];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {

        NSInteger currentTime = self.playerItem.currentTime.value/self.playerItem.currentTime.timescale;        
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);

        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZJAvPlayerView:progress:totle:)]) {
            [self.delegate ZJAvPlayerView:self progress:currentTime totle:totlePlayTime];
        }

    }
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

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest NS_AVAILABLE(10_9, 6_0) {
    [self addLoadingRequest:loadingRequest];
    return YES;
}

-(void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
}

- (void)addLoadingRequest:(AVAssetResourceLoadingRequest *)request {
    [self.requestList addObject:request];    
    
}



- (NSMutableArray *)requestList {
    if (!_requestList) {
        _requestList = [[NSMutableArray alloc] init];
    }
    return _requestList;
}

@end
