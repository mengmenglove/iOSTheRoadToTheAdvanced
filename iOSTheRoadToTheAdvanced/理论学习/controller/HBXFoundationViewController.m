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
    [self showExpress];
    // Do any additional setup after loading the view.
}

- (void)fileWrite {
    //文件追加
//    NSString *homePath = NSHomeDirectory( );
//    NSString *sourcePath = [NSString stringWithFormat:@"%@testfile.text", homePath] ;
//    NSFileHandle *fielHandle = [NSFileHandle fileHandleForUpdatingAtPath:sourcePath];
//    [fileHandle ];
//    NSString *str = @"追加的数据";
//    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [fileHandle writeData:stringData]; 追加写入数据[fileHandle closeFile];
    
  
}

- (void)showExpress {
    //1 做数学题  简单表达式
    NSExpression *expression = [NSExpression expressionWithFormat:@"4 + 5 - 2**3"];
    id value = [expression expressionValueWithObject:nil context:nil]; // => 1
    NSLog(@"%@", value);
    
    
    
    
    NSArray *numbers = @[@(6), @(8)];
    NSExpression *addexpression = [NSExpression expressionForFunction:@"max:" arguments:@[[NSExpression expressionForConstantValue:numbers]]];
    /*
     fucntion
     average:
     sum:
     count:
     min:
     max:
     median:
     mode:
     */
    value = [addexpression expressionValueWithObject:nil context:nil];
    NSLog(@"%@", value);
    
    
    /*
     * 基本运算
     add:to:
     from:subtract:
     multiply:by:
     divide:by:
     modulus:by:
     abs:
     
     
     */
    
    
    /*
     *高级运算
     
     sqrt:
     log:
     ln:
     raise:toPower:
     exp:

     */
    
    
    /*
     * 随机函数
     random
     random:
     */
    
    /*
     * 二进制运算
     bitwiseAnd:with:
     bitwiseOr:with:
     bitwiseXor:with:
     leftshift:by:
     rightshift:by:
     onesComplement:
     */
    
    
    /*日期函数
     *
     now
     */
    
    /*字符串函数
     *
     lowercase:
     uppercase:
     */
    
    
    /*空操作
     *
     noindex:
     */
    
    
    /*自定义函数
     
     @interface NSNumber (Factorial)
     - (NSNumber *)factorial;
     @end
     
     @implementation NSNumber (Factorial)
     - (NSNumber *)factorial {
     return @(tgamma([self doubleValue] + 1));
     }
     @end
     
     NSExpression *expression = [NSExpression expressionWithFormat:@"FUNCTION(4.2, 'factorial')"];
     id value = [expression expressionValueWithObject:nil context:nil]; // 32.578...
     
     *
     */


}

- (void)showCharactor {

    /*
     NSString * str =  [NSByteCountFormatter stringFromByteCount:10929292 countStyle:NSByteCountFormatterCountStyleFile];
     NSLog(@"str: %@", str);
     "str: 10.9 MB"
     */
    
     UInt16  Byte = 0x1234;
     HTONS(Byte);//转换
     NSLog(@"Byte == %x",Byte);
    // 3412
    
    
    
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
    
    
}

- (void)showNSPredicate {
    
    //基础过滤
    NSMutableArray *array=[NSMutableArray array];//\n
    [array addObject:[[HBXLearnModel alloc] initWith:@"lww" age:20]];//\n
    [array addObject:[[HBXLearnModel alloc] initWith:@"wy" age:20]];//\n
    [array addObject:[[HBXLearnModel alloc] initWith:@"LWW" age:21]];//\n
    [array addObject:[[HBXLearnModel alloc] initWith:@"sunshinelww" age:22]];//\n
    
    NSPredicate *basicPredicate=[NSPredicate predicateWithFormat:@"name = 'lww'"];//\n
    //基础过滤//\n
    [array filterUsingPredicate: basicPredicate]; //通过条件表达式筛选数组元素//\n
    
    NSMutableArray *predicateArray=[NSMutableArray array];//\n
    NSPredicate *basicPredicate1=[NSPredicate predicateWithFormat:@"name = 'lww'"];//\n
    NSPredicate *basicPredicate2=[NSPredicate predicateWithFormat:@"age = 20"];[predicateArray addObject: basicPredicate1];//\n
    [predicateArray addObject: basicPredicate2];//\n
    
    //    NSCompoundPredicate *orMatchPredicate=[NSCompoundPredicate orPredicateWithSubpredicates:predicateArray]; ///对//\n数组中的谓词表达式取或
    //    [array filterUsingPredicate:orMatchPredicate];//\n
    //    NSLog(@"array after: %@", array);//\n
    
    
    //    NSCompoundPredicate *andMatchPredicate=[NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];///对数组中的谓词表达式取与//\n
    //    [array filterUsingPredicate:andMatchPredicate];//\n
    //    NSLog(@"array after: %@", array);//\n
    
    
    //    NSCompoundPredicate *noMatchPredicate = [NSCompoundPredicate notPredicateWithSubpredicate://\n basicPredicate1]; ///对basicPredicate1取反//\n
    //    [array filterUsingPredicate:noMatchPredicate];//\n
    //    NSLog(@"array after: %@", array);//\n
    
    
}

- (void)showEnumeratorAction {
    NSArray *newArray = @[@"1", @"2", @"3"];
    NSEnumerator *enumtrator = [newArray objectEnumerator];
    NSString *obj = nil;
    while (obj  = [enumtrator nextObject]) {
        NSLog(@"obj: %@", obj);
    }
}

- (void)getExceotionAction {
    //异常的名称
    NSString *exceptionName = @"自定义异常";
    //异常的原因
    NSString *exceptionReason = @"我长得太帅了，所以程序崩溃了";
    //异常的信息
    NSDictionary *exceptionUserInfo = nil;
    
    NSException *exception = [NSException exceptionWithName:exceptionName reason:exceptionReason userInfo:exceptionUserInfo];
    
    NSString *aboutMe = @"太帅了";
    
    if ([aboutMe isEqualToString:@"太帅了"]) {
        //抛异常
        @throw exception;
    }
    
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
