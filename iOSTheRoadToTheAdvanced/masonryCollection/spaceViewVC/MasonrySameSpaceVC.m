//
//  MasonrySameSpaceVC.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/10.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "MasonrySameSpaceVC.h"

@interface MasonrySameSpaceVC ()
@property (nonatomic, strong) UIView *firstView;
@end

@implementation MasonrySameSpaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
 
    self.firstView = [[UIView alloc] init];
    [self.view addSubview:self.firstView];
    self.firstView.backgroundColor = [UIColor greenColor];
    
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.width.equalTo(self.view).multipliedBy(0.3);
        make.height.mas_equalTo(100);
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
