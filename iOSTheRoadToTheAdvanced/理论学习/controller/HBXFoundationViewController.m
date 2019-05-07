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
#import "HBXOperation.h"

@interface HBXFoundationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) HBXOperation *operation;

@end

@implementation HBXFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self initData];
    [self showHasTableAndMapTable];
    // Do any additional setup after loading the view.
   
    
    [self showOperationAction];
 
}

- (void)showOperationAction {
    
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
//    [operation start];

//    NSBlockOperation *operationBlock = [NSBlockOperation blockOperationWithBlock:^{
//
//    }];
//    [operationBlock start];
    
    self.operation = [[HBXOperation alloc] init];
    //功能点1 添加依赖
//    [operation addDependency:]
    //功能点2 添加优先级
    self.operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
//    //获取的队列为主线程队列
//    [queue addOperation:operation];
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperation:self.operation];
    
}

- (void)task1 {
    for (int i =0 ; i < 100; i++) {
        NSLog(@"%d %@", i , [NSThread currentThread]);
    }
    
}


- (void)unitChange {
    // 初始化一个秒数的基数
    NSMeasurement *seconds = [[NSMeasurement alloc] initWithDoubleValue:666
                                                                   unit:NSUnitDuration.seconds];
    
    // 转换为分钟
    NSMeasurement *minutes = [seconds measurementByConvertingToUnit:NSUnitDuration.minutes];
    
    // 转换为小时
    NSMeasurement *hours   = [seconds measurementByConvertingToUnit:NSUnitDuration.hours];
    
    NSString *secondsString = [NSString stringWithFormat:@"%.2f 秒", seconds.doubleValue];
    NSString *minutesString = [NSString stringWithFormat:@"%.2f 分钟", minutes.doubleValue];
    NSString *hoursString   = [NSString stringWithFormat:@"%.2f 小时", hours.doubleValue];

}


- (void)showlock {
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int j = 0;
    dispatch_async(queue, ^{
        j = 100;
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"finish j = %zd", j);
     */
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            // 相当于加锁
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"i = %zd semaphore = %@  %@", i, semaphore, [NSThread currentThread]);
            // 相当于解锁
            dispatch_semaphore_signal(semaphore);
        });
    }
     
}




- (void)useLinguisticTagger {
    //1.创建语句
    NSString * question = @"What is the weather in San Francisco?";
    //2.创建筛选条件
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerJoinNames |NSLinguisticTaggerOmitPunctuation;
    //3.创建自然语言标签
    NSLinguisticTagger * tagger = [[NSLinguisticTagger alloc]initWithTagSchemes:[NSLinguisticTagger availableTagSchemesForLanguage:@"en"] options:options];
    //4.给标签附字符串
    tagger.string = question;
    //5.执行筛选
    [tagger enumerateTagsInRange:NSMakeRange(0, question.length) scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass  options:options usingBlock:^(NSString * _Nonnull tag, NSRange tokenRange, NSRange sentenceRange, BOOL * _Nonnull stop) {
        
        //6.获取结果
        NSString*token = [question substringWithRange:tokenRange];
        
        //7.打印结果
        NSLog(@"%@:%@",token,tag);
    }];
    
}


- (void)showKeyArchiveFunction {
    if (![self decodingDelegate]) {
        [self codingDelegate];
    }
}

- (void)codingDelegate {
    NSMutableArray *writeArray = [NSMutableArray array];
    HBXLearnModel *model = [[HBXLearnModel alloc] init];
    model.name = @"zhangq";
    model.age = 30;
    [writeArray addObject:model];
    
    
    HBXLearnModel *model1 = [[HBXLearnModel alloc] init];
    model1.name = @"huangbx";
    model1.age = 28;
    [writeArray addObject:model1];
    
    
    NSString *arrayPath = [NSString stringWithFormat:@"%@%@", [self getDocumentPath], @"array.plist"];
    [NSKeyedArchiver archiveRootObject:writeArray toFile:arrayPath];
    
}

- (BOOL)decodingDelegate {
    NSString *arrayPath = [NSString stringWithFormat:@"%@%@", [self getDocumentPath], @"array.plist"];

    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:arrayPath];
    if (array.count > 0) {
        NSLog(@"获取文件成功");
        return YES;
    }
    NSLog(@"获取文件失败");
    return NO;
}

- (NSString *)getDocumentPath {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (documents.count > 0) {
        return documents[0];
    }
    NSLog(@"路径为空");
    return nil;
}


- (void)useNSInvocation {
    
    //获取方法签名
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sendMessageWithNumber:WithContent:)];
    
    //方法执行
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = @selector(sendMessageWithNumber:WithContent:);
    NSString *number = @"1111";
    NSString *content = @"打印日志";
    //注意：设置参数的索引时不能从0开始，因为0已经被self占用，1已经被_cmd占用
    [invocation setArgument:&number atIndex:2];
    [invocation setArgument:&content atIndex:3];
    // 调用invocation的执行方法
    [invocation invoke];
    
    
    
    
}
- (void)sendMessageWithNumber:(NSString*)number WithContent:(NSString*)content{
    NSLog(@"电话号%@,内容%@",number,content);
}

- (void)showHasTableAndMapTable {
    NSHashTable *hashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsCopyIn];
    [hashTable addObject:@"foo"];
    [hashTable addObject:@"bar"];
    [hashTable addObject:@42];
    [hashTable removeObject:@"bar"];
    NSLog(@"Members: %@", [hashTable allObjects]);
    
    
    id delegate = @32;
    NSMapTable *mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                                 valueOptions:NSMapTableWeakMemory];
    [mapTable setObject:delegate forKey:@"foo"];
    NSLog(@"Keys: %@", [[mapTable keyEnumerator] allObjects]);
//    NSMapTableStrongMemory
//    NSMapTableWeakMemory
//    NSHashTableZeroingWeakMemory
//    NSMapTableCopyIn
//    NSMapTableObjectPointerPersonality
//    Subscripting
    
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
    //详情见 ZJDownloadCenterManagaer
    
    
    
  
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
