//
//  DesignMViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/7.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "DesignMViewController.h"

@interface DesignMViewController ()

@end

@implementation DesignMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     1 mvc:
     
     
     
     
     
     
     2 mvp:
     
     Presenter <=> view
     
     Presenter <=> model
     
     交互方式通过接口传递（协议）
     
     view与model没有任何联系
     
     view获取数据是通过接口获取
     
     
     
     
     3 mvvm  响应式变成
     
     view <==> viewModel <==> model
     
     
     
     **/
    
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
