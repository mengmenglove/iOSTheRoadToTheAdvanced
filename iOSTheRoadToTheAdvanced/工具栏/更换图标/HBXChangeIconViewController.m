//
//  HBXChangeIconViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/8/26.
//  Copyright © 2018年 黄保贤. All rights reserved.
//
/*
 注意,需要在 plist 中添加
 NSDictionary *infoPlist;
 infoPlist = @{
 @"CFBundleIcons" : @{
 @"CFBundlePrimaryIcon" : xxx,
 @"CFBundleAlternateIcons" : xxx,
 @"UINewsstandIcon" : xxx
 }
 };
 */
#import "JDUtils.h"


#import "HBXChangeIconViewController.h"

@interface HBXChangeIconViewController ()

@end

@implementation HBXChangeIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断是否支持更换图标
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        UILabel *label =[JDUtils createLabelWithFrame:CGRectMake(100, 100, 200, 30) Font:15 Text:@"当前系统不支持更换图标"];
        [self.view addSubview:label];
    }
    else
    {
        UIButton *button =[JDUtils createSystemButtonWithFrame:CGRectMake(100, 140, 150, 30) Target:self Action:@selector(buttonClick1) Title:@"更换晴天图标"];
        
        [self.view addSubview:button];
        
        UIButton *button2 =[JDUtils createSystemButtonWithFrame:CGRectMake(100, 240, 150, 30) Target:self Action:@selector(buttonClick2) Title:@"更换天气图标"];
        [self.view addSubview:button2];
        
        UIButton *button3 =[JDUtils createSystemButtonWithFrame:CGRectMake(100, 340, 150, 30) Target:self Action:@selector(buttonClick3) Title:@"还原图标"];
        [self.view addSubview:button3];
    }
}

- (void)buttonClick1 {
    
    [[UIApplication sharedApplication] setAlternateIconName:@"晴" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换 icon 失败");
        }
    }];
    
}

- (void)buttonClick2 {
    [[UIApplication sharedApplication] setAlternateIconName:@"天气" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换 icon 失败");
        }
    }];
}

- (void)buttonClick3 {
    //还原图标
    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换 icon 失败");
        }
    }];
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
