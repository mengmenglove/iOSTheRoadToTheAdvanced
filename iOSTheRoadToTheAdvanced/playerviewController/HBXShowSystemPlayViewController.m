//
//  HBXShowSystemPlayViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/8/15.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HBXShowSystemPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HBXShowSystemPlayViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation HBXShowSystemPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
     [self.dataArray addObject:@{@"title":@"avplayer"}];//AVPlayer
     [self.dataArray addObject:@{@"title":@"MPMoviePlayerController"}];//9.0 弃用
     [self.dataArray addObject:@{@"title":@"MPMoviePlayerViewController"}];//9.0弃用
     [self.dataArray addObject:@{@"title":@"AVPlayerViewController"}];// 8.0之后有效
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
                {
                    [self showAvPlayer];
                }
            break;
        case 1:
                {
                    [self showMoviePlayerController];
                    
                }
            break;
        case 2:
                {
                    [self showMPMoviePlayerViewController];
                }
            break;
        case 3:
                {
                    [self showGuideVdeio];
                }
            break;
            
        default:
            break;
    }
    
}

- (void)showAvPlayer {
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"backspace" ofType:@"mov"];
    NSURL *sourceMovieURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    
//    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    playerLayer.frame = self.view.layer.bounds;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    
    [player play];
    
}


- (void)showMPMoviePlayerViewController {
    
        NSURL *url = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//        NSString *file = [[NSBundle mainBundle] pathForResource:@"sonPlayer" ofType:@"mp4"];
//        NSURL *url = [NSURL fileURLWithPath:file];
        //    NSURL *url = [NSURL URLWithString:@"http://dazhao.sinaapp.com/lovetosa/abc.mp4"];
        //2.创建视频播放控制器
        MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        //3.弹出视频播放控制器
        [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)showMoviePlayerController {
    NSURL *url = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    MPMoviePlayerViewController   *   _playerVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    _playerVc.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    _playerVc.moviePlayer.controlStyle = MPMovieControlStyleDefault ;
    [_playerVc.moviePlayer prepareToPlay];
    [_playerVc.moviePlayer  play];
    _playerVc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:_playerVc animated:YES];
    
}

- (void)showGuideVdeio {
   
    
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"sonPlayer" ofType:@"mp4"];
    
    //    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURL *url = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    
    AVPlayerViewController  *playerView = [[AVPlayerViewController alloc] init];
    
    playerView.player = [[AVPlayer alloc] initWithURL:url];
    
    // 是否显示视频播放控制控件默认YES
    playerView.showsPlaybackControls = YES;
    
    // 设置视频播放界面的尺寸播放选项
    // AVLayerVideoGravityResizeAspect   默认 不进行比例缩放 以宽高中长的一边充满为基准
    // AVLayerVideoGravityResizeAspectFill 不进行比例缩放 以宽高中短的一边充满为基准
    // AVLayerVideoGravityResize     进行缩放充满屏幕
    playerView.videoGravity = @"AVLayerVideoGravityResizeAspect";
    
    // 获取是否已经准备好开始播放
    //    play.isReadyForDisplay
    
    // 获取视频播放界面的尺寸
    //    play.videoBounds
    
    // 视频播放器的视图 自定义的控件可以添加在其上
    //    play.contentOverlayView
    
    // 画中画代理iOS9后可用
    //    self.playerView.delegate = self;
    
    // 是否支持画中画 默认YES
    //    self.playerView.allowsPictureInPicturePlayback = YES;
    
    
    [playerView.player play];
    [self presentViewController:playerView animated:YES completion:nil];
//    [AppNavigator showModalViewController:playerView animated:YES];
    //    [self presentViewController:play animated:YES completion:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier  = @"uiviewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (dict) {
        cell.textLabel.text = dict[@"title"];
    }
    return cell;
}




- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;

}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];

    }
    return _dataArray;
}



@end
