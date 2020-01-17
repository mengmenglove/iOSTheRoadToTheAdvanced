//
//  RunloopTableViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2020/1/14.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "RunloopTableViewController.h"
#import "RunloopCell.h"

@interface RunloopTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray  *cellArray;
@property(nonatomic, assign) NSInteger  count;
@end

@implementation RunloopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[RunloopCell class] forCellReuseIdentifier:@"RunloopCell"];
//    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    [self addRunloopOberser];
    
    [self testDemo1];
    
}

- (void)testDemo1 {
    
    int a = 5;
    if (a & 5) {
        NSLog(@"a是5");
        a |= 6;
        NSLog(@"a : %d",a);
    }else {
        NSLog(@"a 不是 5");
        a |= 5;
        NSLog(@"a : %d",a);
    }
    
}

- (void)addRunloopOberser {

    
    CFRunLoopObserverContext context = {
            NULL,
            (__bridge void *)(self.cellArray),
            &CFRetain,
            &CFRelease,
            NULL,
    };
    
   CFRunLoopObserverRef observerRef =
CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observerRef, kCFRunLoopCommonModes);
    
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSMutableArray *array = (__bridge NSMutableArray *)(info);
//    NSLog(@"come here %@", info);
    if (array.count > 0) {
       
        void (^action)(void) = array[0];
        action();
        [array removeObjectAtIndex:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RunloopCell"];
    self.count++;
//    NSLog(@"self.count : %ld", (long)self.count);
    
    [self addCellTask:^{
         [(RunloopCell *)cell updateDetailImages];
    }];
    return cell;
}

- (void)addCellTask:(void(^)(void))cellTask {
    if (cellTask) {
        [self.cellArray addObject:cellTask];
    }
}


- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [[NSMutableArray alloc] init];
    }
    return _cellArray;
}

@end
