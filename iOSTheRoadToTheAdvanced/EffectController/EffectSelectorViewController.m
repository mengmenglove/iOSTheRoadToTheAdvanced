//
//  EffectSelectorViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/9.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "EffectSelectorViewController.h"

@interface EffectSelectorViewController ()

@end

@implementation EffectSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self relfreshUi];
    [self creatData:@"qq导航栏效果" target:@"TrScrollViewController"];
    [self.tableView reloadData];
    
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
