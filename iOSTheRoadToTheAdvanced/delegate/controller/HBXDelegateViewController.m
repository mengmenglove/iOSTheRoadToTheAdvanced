//
//  HBXDelegateViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/7.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HBXDelegateViewController.h"

@interface HBXDelegateViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView  *table;
@property (nonatomic,strong) NSMutableArray  *dataArray;
@end

@implementation HBXDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
   
   
    /**
     消息转发
     - (id)forwardingTargetForSelector:(SEL)aSelector OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
     
     标准消息转发
     - (void)forwardInvocation:(NSInvocation *)anInvocation
     
     
     动态方法解析
     + (BOOL)resolveClassMethod:(SEL)sel OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
     + (BOOL)resolveInstanceMethod:(SEL)sel OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
     
     */
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
