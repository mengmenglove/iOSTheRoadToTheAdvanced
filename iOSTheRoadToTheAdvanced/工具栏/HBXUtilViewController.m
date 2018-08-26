//
//  HBXUtilViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/8/26.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HBXUtilViewController.h"
#import "JDDeviceUtils.h"
#import "JDLoadingView.h"
#import "JDGuidePageView.h"
#import "JDIDCardScanViewController.h"
#import "JDBankScanViewController.h"
#import "JDUtils.h"
#import "HBXTouchIDViewController.h"
#import "HBXBaseAnimalViewController.h"

typedef void(^ActionBlock)(int a);

@interface HBXUtilViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,retain)UIImageView *firstImageView;
@property(nonatomic,retain)UIButton *secondButton;
@property(nonatomic,retain)UILabel *thirdLabel;



@end

@implementation HBXUtilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initData];
    // Do any additional setup after loading the view.
}


- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
 
    [self.view addSubview:self.tableView];
    
}

- (void)initData {
    
    [self.dataArray addObject:@{@"title":@"机器类型",@"action":^(int param){
        NSLog(@"%d", [JDDeviceUtils deviceType]);
        
    } }];
    
    __weak typeof(self) weakSelf = self;
    [self.dataArray addObject:@{@"title":@"loading框",@"action":^(int param){
        [JDLoadingView showView:weakSelf.view];
        
    } }];
    
    [self.dataArray addObject:@{@"title":@"引导图",@"action":^(int param){
        [weakSelf createGuide];
        
    } }];
    
    [self.dataArray addObject:@{@"title":@"身份证识别",@"action":^(int param){
        JDIDCardScanViewController *vc = [[JDIDCardScanViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];        
    } }];
    
    [self.dataArray addObject:@{@"title":@"银行卡识别",@"action":^(int param){
        JDBankScanViewController *vc = [[JDBankScanViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } }];
    
    
    [self.dataArray addObject:@{@"title":@"touchID识别",@"action":^(int param){
        HBXTouchIDViewController *vc = [[HBXTouchIDViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } }];
    
    
    [self.dataArray addObject:@{@"title":@"基础动画",@"action":^(int param){
        HBXBaseAnimalViewController *vc = [[HBXBaseAnimalViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } }];
    
    [self.tableView reloadData];
}


- (void)createGuide {
    
    JDGuidePageView *guideView =[[JDGuidePageView alloc]initGuideViewWithImages:@[@"guide_01", @"guide_02", @"guide_03"] ];
    guideView.isShowPageView = YES;
    guideView.isScrollOut = NO;
    guideView.currentColor =[UIColor redColor];
    [self.view addSubview:guideView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    ActionBlock block = dict[@"action"];
    if (block) {
        block(1);
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    return cell;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
