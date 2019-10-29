//
//  LiveController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/10/12.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "LiveController.h"

@interface LiveController ()

@property (nonatomic, strong) UIImageView *bottomImageView;
/** 滑杆 */
@property (nonatomic, strong) UISlider   *videoSlider;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
@property (nonatomic, strong) UIView *panView;
/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
@property (nonatomic, assign) NSInteger playTotleTime;
@property (nonatomic, assign) NSInteger currentPlayTime;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *totleTimeLabel;


@end

@implementation LiveController

- (instancetype)init {
    if (self = [super init]) {
        [self creatSubView];
    }
    return self;
}


- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 更新slider
    self.videoSlider.value           = value;
    // 更新当前播放时间
    self.progressLabel.text = [self timeFormat:currentTime];

    self.currentPlayTime = currentTime;
    // 更新总时间
    self.totleTimeLabel.text = [self timeFormat:totalTime];
}

- (NSString *)timeFormat:(NSInteger)totalTime {
    if (totalTime < 0) {
        return @"";
    }
    NSInteger durHour = totalTime / 3600;
    NSInteger durMin = (totalTime / 60) % 60;
    NSInteger durSec = totalTime % 60;
    
    if (durHour > 0) {
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", durHour, durMin, durSec];
    } else {
        return [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        [self playerShowOrHideControlView];
        
    }
}


- (void)playerShowOrHideControlView {
    if (self.isShowing) {
        [self playerHideControlView];
    } else {
        [self playerShowControlView];
    }
}
/**
 *  显示控制层
 */
- (void)playerShowControlView {
    if ([self.delegate respondsToSelector:@selector(onControlViewWillShow:isFullscreen:)]) {
        [self.delegate onControlViewWillShow:self isFullscreen:YES];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
    }];
}


/**
 *  隐藏控制层
 */
- (void)playerHideControlView {
    if ([self.delegate respondsToSelector:@selector(onControlViewWillHidden:isFullscreen:)]) {
        [self.delegate onControlViewWillHidden:self isFullscreen:NO];
    }
    //    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:0.5 animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

- (void)showControlView {
    self.showing = YES;
    self.backgroundColor             = [UIColor clearColor];
    self.bottomImageView.hidden = NO;
    
}

- (void)hideControlView {
    self.showing = NO;
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.bottomImageView.hidden = YES;
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(onControlView:progressSliderTouchBegan:)]) {
        [self.delegate onControlView:self progressSliderTouchBegan:sender];
    }
}


- (void)creatSubView {
    [self addSubview:self.panView];
    [self addSubview:self.bottomImageView];
    
    [self.bottomImageView addSubview:self.progressLabel];
    [self.bottomImageView addSubview:self.videoSlider];
    [self.bottomImageView addSubview:self.totleTimeLabel];

    
    
    [self.panView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self);
    }];
    
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    
    UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    //    self.singleTap.delegate                = self;
    tapGuest.numberOfTouchesRequired = 1; //手指数
    tapGuest.numberOfTapsRequired    = 1;
    [self.panView addGestureRecognizer:tapGuest];
    
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomImageView);
        make.leading.equalTo(self.bottomImageView).offset(15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.progressLabel.mas_trailing).offset(4);        make.trailing.equalTo(self.totleTimeLabel.mas_leading).offset(-20);
         make.centerY.equalTo(self.bottomImageView);
        make.height.mas_equalTo(30);
    }];
    
    [self.totleTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomImageView);
        make.trailing.equalTo(self.bottomImageView).offset(-15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    CGFloat totalMovieDuration = self.playTotleTime;
    self.sumTime= totalMovieDuration * sender.value;
//    [self playerDraggedTime:self.sumTime totalTime:totalMovieDuration];
//
    if ([self.delegate respondsToSelector:@selector(onControlView:progressSliderValueChanged:)]) {
        [self.delegate onControlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    self.showing = YES;
    [self playerDraggedEnd];
    if ([self.delegate respondsToSelector:@selector(onControlView:progressSliderTouchEnded:)]) {
        [self.delegate onControlView:self progressSliderTouchEnded:sender];
    }
}
/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        if ([self.delegate respondsToSelector:@selector(onControlView:progressSliderTap:)]) {
            [self.delegate onControlView:self progressSliderTap:self.videoSlider.value];
        }
    }
}


- (void)playerDraggedEnd {
//    self.enableSeekProgress = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.fastTimeLabel.hidden = YES;
//        self.fastLightImgView.hidden = YES;
//        self.fastVolumeImgView.hidden = YES;
//        self.fastView.hidden = YES;
//    });
//    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = NO;
    // 滑动结束延时隐藏controlView
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onControlView:panTouchEnded:)]) {
            [self.delegate onControlView:self panTouchEnded:self.videoSlider];
        }
    });
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image = [UIImage imageWithColor:UIColorFromRGBA(0x000000, 0.7)];
    }
    return _bottomImageView;
}


- (UIView *)panView {
    if (!_panView) {
        _panView = [[UIView alloc] init];
        _panView.userInteractionEnabled = YES;
    }
    return _panView;
}

- (UISlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[UISlider alloc] init];
        
        
        [_videoSlider setThumbImage:[UIImage imageNamed:(@"slider_thumb")] forState:UIControlStateNormal];
        _videoSlider.minimumValue = 0;
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor redColor];
        _videoSlider.maximumTrackTintColor = [UIColor whiteColor];//[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
//        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
//        [_videoSlider addGestureRecognizer:sliderTap];
        
    }
    return _videoSlider;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        //标题
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = UIColorFromRGB(0xffffff);
        _progressLabel = label;
    }
    return _progressLabel;
}


- (UILabel *)totleTimeLabel {
    if (!_totleTimeLabel) {
        //标题
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = UIColorFromRGB(0xffffff);
        _totleTimeLabel = label;
    }
    return _totleTimeLabel;
}



@end
