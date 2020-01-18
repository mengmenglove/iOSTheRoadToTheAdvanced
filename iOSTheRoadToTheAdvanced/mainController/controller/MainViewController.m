//
//  MainViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2017/12/21.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "MainViewController.h"
#import "MainSubViewViewController.h"


@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>


@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,strong)UITableView  *tableView ;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self loadConfig];
    [self relfreshUi];
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)relfreshUi {
    [self.view addSubview:self.tableView];
}

#pragma mark - private

- (void)loadConfig {
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"controllerConfig" ofType:@"json"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSError *error = nil;
    NSDictionary *dict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *array = dict[@"links"];
    if (array && array.count > 0) {
        [self.dataArray addObjectsFromArray:array];
    }
}

#pragma mark - tableViewDelegate datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    MainSubViewViewController *mainVC = [[MainSubViewViewController alloc] initWithArray:dict[@"data"]];
    [self.navigationController pushViewController:mainVC animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    static NSString *identifier  = @"uiviewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }

    NSDictionary *dict = self.dataArray[indexPath.row];
    if (dict) {
        cell.textLabel.text = dict[@"title"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
