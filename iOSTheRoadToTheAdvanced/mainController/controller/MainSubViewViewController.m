//
//  MainSubViewViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/9.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "MainSubViewViewController.h"

@interface MainSubViewViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property(nonatomic,strong)UITableView  *tableView ;

@end

@implementation MainSubViewViewController

- (instancetype)initWithArray:(NSArray *)dataArray {
    if (self = [super init]) {
        self.dataArray = dataArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self relfreshUi];
    // Do any additional setup after loading the view.
}

- (void)relfreshUi {
    [self.view addSubview:self.tableView];
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
    return 60;
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


- (UITableView *)tableView {
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
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
