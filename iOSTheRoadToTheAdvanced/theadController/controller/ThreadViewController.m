//
//  ThreadViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2017/12/22.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "ThreadViewController.h"
#import "BaoXianOperation.h"
@interface ThreadViewController ()

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Thread";
    self.view.backgroundColor = [UIColor grayColor];

    [self GCDOnce];
    
}

- (void)threadToMainQueue {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"hello world");
    });
    
}

- (void)GCDOnce {
    static dispatch_once_t onceToken;
   
    dispatch_once(onceToken, ^{
    });
}

- (void)GCDAfter {    
    // dispath after 应用
    dispatch_after(3.0, dispatch_get_main_queue(), ^{
        NSLog(@"GCDAfter is %@", [NSThread currentThread]);
    });

    dispatch_queue_t t = dispatch_queue_create("baoxianhrll", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 *NSEC_PER_SEC));
    
    dispatch_after(time, t , ^{
       NSLog(@"GCDAfter1 is %@", [NSThread currentThread]);
    });
}


- (void)operation3 {
    //多线程3，自定义的nsoperation
    // 继承NSOPeration 实现main 方法
    BaoXianOperation *operantion1  = [[BaoXianOperation alloc] init];
    BaoXianOperation *operantion2  = [[BaoXianOperation alloc] init];
    BaoXianOperation *operantion3  = [[BaoXianOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperations:@[operantion1, operantion2, operantion3] waitUntilFinished:YES];

}


- (void)opearation2 {
    
    // operation的串行
    // 设置queue 的maxConcurrentOperationCount
    // 并且operation还可以添加依赖
    
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"opearation2 打印自己 %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"opearation2 打印水印 %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"opearation2 上传文件 %@", [NSThread currentThread]);
    }];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 如果设置为1的话，则变成了GCD的串行队列
    [queue setMaxConcurrentOperationCount:1];
    
    //添加依赖  不能添加相互依赖，会行程死锁
//    [operation2 addDependency:operation1];
//    [operation3 addDependency:operation2];
    
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    
  
    
    
    
    
    
    
}

- (void)operation1 {

    //这种创建线程的方式不是安全的 1
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(action2) object:nil];
//
//    [operation start];
    // 这是第二中创建NSOPerationQueue 方式
    __weak typeof(self) unself = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [unself action2];
    }];
    
    for (int i = 0; i < 20; i++) {
        [blockOperation addExecutionBlock:^{
            NSLog(@"operation1 %@", [NSThread currentThread]);
        }];
    }
    [blockOperation start];
    //第三种创建 NSOPerationQueue 的方式是通过自定义类继承抽象类opeation实现的
}

/*
 *
 */
- (void)thread1 {
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"线程打印 %@ ", [NSThread currentThread]);
    }];
    [thread start];
    
}

- (void)thread2 {
    
    [NSThread detachNewThreadSelector:@selector(action1) toTarget:self withObject:nil];
    
}

- (void)GCD1 {
    
    //创建队列
    //创建主队列
    dispatch_queue_t main_t = dispatch_get_main_queue();
    
    //串行队列
    
    dispatch_queue_t chuan_t = dispatch_queue_create("baoxianlookBooking", NULL);
    
    //并行队列
    dispatch_queue_t bing_t = dispatch_queue_create("baoxian_bing_action", DISPATCH_QUEUE_CONCURRENT);
    
    //全局并行队列
    dispatch_queue_t global_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    

    // 创建队列组
    
    dispatch_group_t  group_t = dispatch_group_create();
    
    dispatch_group_async(group_t, bing_t, ^{
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"group-01 - %@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group_t, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group_t, chuan_t, ^{
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"group-3 - %@", [NSThread currentThread]);
        }
    });
    
    
    dispatch_group_notify(group_t, dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_group_notify %@ %@", [NSThread currentThread], group_t);
    });
    
    
    //可以阻塞任务的GCD
    dispatch_barrier_async(bing_t, ^{
        NSLog(@"dispatch_barrier_sync is %@", [NSThread currentThread]);
    });
    
    
    
    
    
//    dispatch_async(global_t, ^{
//        [self action3];
//    });
//
//    dispatch_async(bing_t, ^{
//
//        [self action3];
//    });
//
//    NSLog(@"[NSThread currentThread] %@" ,[NSThread currentThread]);

}


- (void)action1 {
    /*
     * action如果有
     *
     *
     */
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(action2) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(action2)
                                   userInfo:nil
                                    repeats:YES];
    
    static BOOL isSuccess = YES;
    while (isSuccess) {
        NSLog(@"111");
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
    NSLog(@"action1 %@", [NSThread currentThread]);
    
}

- (void)action2 {

    NSLog(@"action2 %@", [NSThread currentThread]);
    
}

- (void)action3 {
    
    NSLog(@" action3 %@", [NSThread currentThread]);
    sleep(2.0);
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
