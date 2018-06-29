//
//  CameraView.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TokePhotoComplete)(id response);

@interface CameraView : UIView

@property (nonatomic, copy) TokePhotoComplete completeBlock;

- (void)tokenPhotoComplete:(TokePhotoComplete)complete;

- (void)rotatePreView;
- (void)stopSession;

@end
