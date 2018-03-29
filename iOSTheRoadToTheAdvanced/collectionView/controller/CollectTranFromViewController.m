//
//  CollectTranFromViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 18/3/29.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "CollectTranFromViewController.h"
#import "HomeHeaderView.h"
@interface CollectTranFromViewController ()
@property(nonatomic,strong) HomeHeaderView *headView;

@end

@implementation CollectTranFromViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.view addSubview:self.headView];
}


-(HomeHeaderView *)headView{
    
    /*
     试了很多次，6张图片效果最佳，所以 目前项目只支持6张图片。请看清楚再添加图片。支持网络图片和本地图片。
     gitHub:https://github.com/TonyDongDong/CollectionView.git
     */
    if (!_headView) {
        
        _headView = [[HomeHeaderView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 250)];
        _headView.imgArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    }
    
    return _headView;
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
