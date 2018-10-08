//
//  HandleLaunchOptionsViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/10/8.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HandleLaunchOptionsViewController.h"

@interface HandleLaunchOptionsViewController ()

@end

@implementation HandleLaunchOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送处理  逻辑";
    
    NSDictionary * launchOptions = nil;
    
    if (launchOptions && launchOptions.count > 0) {
        //获取远程推送消息
        NSDictionary *remoteCotificationDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteCotificationDic && remoteCotificationDic.count > 0) {
            
        }
        
        // 获取本地推送通知
         UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotification) {
            
        }
        //app 通过urlscheme启动
        NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        if (url) {
            NSLog(@"app 通过urlscheme启动 url = %@",url);
        }
        
        
        
        
        
        
    }
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
