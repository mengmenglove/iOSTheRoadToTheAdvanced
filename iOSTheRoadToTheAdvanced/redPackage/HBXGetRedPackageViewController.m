//
//  HBXGetRedPackageViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/8/26.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HBXGetRedPackageViewController.h"
#import "WSRedPacketView.h"
#import "WSRewardConfig.h"


@interface HBXGetRedPackageViewController ()

@end

@implementation HBXGetRedPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *redPacketButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80,self.view.frame.size.height - 120, 48, 48)];
    [redPacketButton setImage:[UIImage imageNamed:@"red_packet"] forState:UIControlStateNormal];
    [redPacketButton addTarget:self action:@selector(openRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redPacketButton];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openRedPacketAction
{
    
    WSRewardConfig *info = ({
        WSRewardConfig *info   = [[WSRewardConfig alloc] init];
        info.money         = 100.0;
        info.avatarImage    = [UIImage imageNamed:@"avatar"];
        info.content = @"恭喜发财，大吉大利";
        info.userName  = @"小雨同学";
        info;
    });
    
    
    [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
        NSLog(@"取消领取");
    } finishBlock:^(float money) {
        NSLog(@"领取金额：%f",money);
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
