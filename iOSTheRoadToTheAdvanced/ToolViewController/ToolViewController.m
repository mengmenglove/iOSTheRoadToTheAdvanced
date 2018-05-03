//
//  ToolViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/5/3.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "ToolViewController.h"

@interface ToolViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic, strong) UITableView  *tableView;

@end

@implementation ToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
    [self.tableView reloadData];
}

- (void)loadDataSource {
    
    NSArray *source = @[ @{@"title":@"imageRatate", @"target":@"UIimageRotateViewController"},
                         @{@"title":@"imageFilter", @"target":@"UIImageFilterViewController"},
                         @{@"title":@"imageBurring", @"target":@"UIImageBurringViewController"}
                         ];
    [self.dataArray addObjectsFromArray:source];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- tableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"imageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *target = dict[@"target"];

    UIViewController *vc = [[NSClassFromString(target) alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
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
