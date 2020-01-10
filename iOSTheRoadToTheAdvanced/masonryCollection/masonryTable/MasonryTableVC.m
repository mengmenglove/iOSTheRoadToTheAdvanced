//
//  MasonryTableVC.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/10.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "MasonryTableVC.h"
#import "MasonryTableCell.h"
#import "MasonryActionItem.h"


@interface MasonryTableVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MasonryTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MasonryTableCell class] forCellReuseIdentifier:@"MasonryTableCellName"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    for (int i = 0; i < 10; i++) {
        MasonryActionItem *item = [[MasonryActionItem alloc] init];
        item.name = [NSString stringWithFormat:@"MasonryActionItem %d",i];
        NSMutableString *str = [NSMutableString string];
        for (int j = 0; j < i; j ++) {
            [str appendFormat:@"%@", @"MasonryActionItem UITableViewStyleGrouped  \nMasonryActionItem UITableViewStyleGrouped\nMasonryActionItem UITableViewStyleGrouped"];
        }
        item.content = str;
        [self.dataArray addObject:item];
    }
    
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
    //方式2
    
    MasonryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasonryTableCellName"];

    MasonryActionItem *item = self.dataArray[indexPath.row];
    
    if (item.cellHeight > 0) {
        return item.cellHeight;
    }else {
        item.cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height + 0.5;
    }
    return item.cellHeight;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasonryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasonryTableCellName" forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        [cell updateItem:self.dataArray[indexPath.row]];
    }
    return cell;
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

@end
