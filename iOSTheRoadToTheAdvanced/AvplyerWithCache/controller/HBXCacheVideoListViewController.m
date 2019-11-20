//
//  HBXCacheVideoListViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/20.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "HBXCacheVideoListViewController.h"
#import "HBXVideoModel.h"
#import "HBXCacheVideoController.h"
#import "ZJLiveFileCacheManager.h"
#import "HBXVideoTableViewCell.h"


static NSString *downLoadkey = @"downLoadkey";

@interface HBXCacheVideoListViewController ()<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *downLoadButton;
@end

@implementation HBXCacheVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadVideoList];
}

- (void)loadVideoList {
    NSArray *list = [HBXVideoModel getVideoKeyList:downLoadkey];
    [self.dataArray removeAllObjects];
    if (list.count > 0) {
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
    }
}

- (void)downloadProgress:(NSInteger)prpgress url:(NSString *)downLoadUrl {
    NSString *str = [NSString stringWithFormat:@"%ld",(long)prpgress];
    [self.downLoadButton setTitle:str forState:UIControlStateNormal];
}

- (void)downloadComplete:(NSString *)downloadUrl {
    [self.downLoadButton setTitle:@"下载" forState:UIControlStateNormal];
    [self loadVideoList];
}

- (void)startDownLoad:(UIButton *)sender {
    if ([self.textFiled.text containsString:@"http"] && self.textFiled.text.length > 0) {
        NSString *url = self.textFiled.text;
        [HBXVideoModel addNewDownLoadWithUrl:url key:downLoadkey];
        [[ZJLiveFileCacheManager getInstance] downloadWithUrl:url delegate:self];
    }
}

- (void)textFiledValueChange:(UITextField *)textFiled {
    NSLog(@"textFiledValueChange %@", textFiled.text);
    if (textFiled.text.length > 0) {
        self.downLoadButton.backgroundColor = [UIColor orangeColor];
    }else {
        self.downLoadButton.backgroundColor = [UIColor grayColor];
    }
}

- (void)creatSubView {
    self.textFiled = [[UITextField alloc] init];
    self.textFiled.frame = CGRectMake(0, 80, self.view.frame.size.width, 50);
    self.textFiled.placeholder = @"请输入url";
    self.textFiled.backgroundColor = [UIColor greenColor];
    [self.textFiled addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textFiled];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"下载" forState:UIControlStateNormal];
    self.downLoadButton.backgroundColor = [UIColor grayColor];
    button.frame = CGRectMake(0, 0 , 100, 50);
    self.textFiled.rightView = button;
    self.textFiled.rightViewMode =  UITextFieldViewModeAlways;
    self.downLoadButton = button;
    [button addTarget:self action:@selector(startDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height - 140);
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"video"];
    if (cell == nil) {
        cell = [[HBXVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"video"];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"url"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    HBXCacheVideoController *vc = [[HBXCacheVideoController alloc] initWithUrl:dict[@"url"]];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
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
