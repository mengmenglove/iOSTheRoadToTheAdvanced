//
//  ZJAvPlayerView.h
//  aizongjie
//
//  Created by huangbaoxian on 2019/10/10.
//  Copyright © 2019 wennzg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJAvPlayerView;

@protocol ZJAvPlayerViewDelegate <NSObject>

- (void)ZJAvPlayerView:(ZJAvPlayerView *)player progress:(NSInteger)progress totle:(NSInteger)totle;
- (void)ZJAvPlayerView:(ZJAvPlayerView *)player status:(ZJAvPlayerViewPlayStatus)status ;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZJAvPlayerView : UIView

@property (nonatomic, assign) id<ZJAvPlayerViewDelegate> delegate;


- (void)startPlayWithUrl:(NSString *)urlStr;
- (void)setFatherView:(UIView *)fatherView rect:(CGRect)rect;
- (void)pasuseVideo;
- (void)resumeVideo;
- (void)stopVideo;
- (void)seekTime:(NSInteger)progress;
- (void)seeSildeTime:(CGFloat)value;
@end

NS_ASSUME_NONNULL_END
