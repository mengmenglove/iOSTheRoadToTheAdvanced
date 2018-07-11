//
//  BaseTableViewController.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/7/9.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView  *tableView ;

- (void)relfreshUi;

- (void)refreshTableView;

- (void)creatData:(NSString *)title target:(NSString *)target;


@end
