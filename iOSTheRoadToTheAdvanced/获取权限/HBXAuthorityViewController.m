//
//  HBXAuthorityViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/8/26.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HBXAuthorityViewController.h"
#import "JDAuthorityManager.h"



@interface HBXAuthorityViewController ()

@end

@implementation HBXAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [JDAuthorityManager requestAllAuthority];
    
    //  Privacy - Camera Usage Description  相机权限
    
    // Privacy - Microphone Usage Description  麦克风权限
    
    //Privacy - Bluetooth Peripheral Usage Description 蓝牙权限
    
    
    //Privacy - NFC Scan Usage Description 需要 nFC
    
    //Privacy - Location Usage Description 位置权限
    
    //Privacy - Contacts Usage Description 访问通讯录
    
    // Privacy - Photo Library Usage Description 设备相册
    
    //Privacy - Speech Recognition Usage Description 语音识别
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
