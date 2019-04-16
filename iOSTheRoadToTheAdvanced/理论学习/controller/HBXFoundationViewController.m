//
//  HBXFoundationViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/4/16.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "HBXFoundationViewController.h"
#import "HBXLearnCell.h"
#import "HBXLearnModel.h"

@interface HBXFoundationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HBXFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self initData];
    
    /*
    NSString * str =  [NSByteCountFormatter stringFromByteCount:10929292 countStyle:NSByteCountFormatterCountStyleFile];
    NSLog(@"str: %@", str);
    "str: 10.9 MB"
    */
    /*
    UInt16  Byte = 0x1234;
    HTONS(Byte);//转换
    NSLog(@"Byte == %x",Byte);
    3412
    */
    NSString *str = @"今天我们来学习NSCharacterSet我们快乐";
    NSString *str1 = @"我s今";
    NSMutableString *resultStr = [[NSMutableString alloc]init];
    for (int i = 0; i < str.length; i++) {
        NSString *indexStr = [str substringWithRange:NSMakeRange(i, 1)];
        if (![str1 containsString:indexStr]) {
            [resultStr appendString:indexStr];
        }
    }

    NSLog(@"%@",resultStr);
    
    // Do any additional setup after loading the view.
}

- (NSString *)getTextWithDict:(NSDictionary *)dict {
    if (!dict) {
        return @"";
    }
    return [NSString stringWithFormat:@"\n%@\n\n%@\n\n",dict[@"name"] ,dict[@"text"]];
}

- (void)initData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"learndata" ofType:@"json"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSError *error = nil;
    NSArray *array  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    [self.dataArray addObjectsFromArray:array];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBXLearnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HBXLearnCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (self.dataArray.count > indexPath.row) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        [cell updateInfo:[self getTextWithDict:dict]];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    return [HBXLearnCell sizeToCellWithText:[self getTextWithDict:dict]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
