//
//  CallPhoneNotificationViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/11/9.
//  Copyright © 2018 黄保贤. All rights reserved.
//

#import "CallPhoneNotificationViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>


@interface CallPhoneNotificationViewController ()

@property (nonatomic, strong) CTCallCenter *callCenter;


@end

@implementation CallPhoneNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  monitorCall];
    // Do any additional setup after loading the view.
}

// 监测电话
- (void)monitorCall {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.callCenter.callEventHandler = ^(CTCall* call) {
            if (call.callState == CTCallStateDisconnected) {
                NSLog(@"电话结束或挂断电话");
            } else if (call.callState == CTCallStateConnected){
                NSLog(@"电话接通");
            } else if(call.callState == CTCallStateIncoming) {
                NSLog(@"来电话");
            } else if (call.callState ==CTCallStateDialing) {
                NSLog(@"拨号打电话(在应用内调用打电话功能)");
            }
        };
    });    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CTCallCenter *)callCenter {
    if (!_callCenter) {
        _callCenter = [[CTCallCenter alloc] init];
    }
    return _callCenter;
}

@end
