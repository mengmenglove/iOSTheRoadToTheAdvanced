//
//  BaseTableViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/9.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)relfreshUi {
    [self.view addSubview:self.tableView];
}

- (void)creatData:(NSString *)title target:(NSString *)target {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"name",target ,@"TrScrollViewController",nil];
    [self.dataArray addObject:dict];
    [self.tableView reloadData];
}


-(void)refreshTableView {
    
}

#pragma mark - private


#pragma mark - tableViewDelegate datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (dict) {
        if (dict && dict[@"target"]) {
            NSString *pushType = dict[@"type"];
            UIViewController *vc = [[NSClassFromString(dict[@"target"]) alloc] init];
            if (pushType && [pushType isEqualToString:@"2"]) {
                [self presentViewController:vc animated:YES completion:nil];
            }else {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier  = @"uiviewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (dict) {
        cell.textLabel.text = dict[@"name"];
    }
    return cell;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
@end
