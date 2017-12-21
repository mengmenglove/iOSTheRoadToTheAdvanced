//
//  RunLoopViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2017/12/21.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "RunLoopViewController.h"

@interface RunLoopViewController ()

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"runLoop";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
   
    [self demo2];
    
    
   
}

/*
 * 在主线程添加一个time
 * 主线程的runloop是个死循环，一直存在，可以一直接收事件
 *
 */
- (void)demo1 {
    NSTimer *time = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:(NSDefaultRunLoopMode)];
    
}


/*
 * 如果[[NSRunLoop currentRunLoop] run] 不开启的话，则当前线程则会被回收，锁添加的任务也不会执行
 *
 *
 */

- (void)demo2 {
    NSThread *thead = [[NSThread alloc] initWithBlock:^{
        
        NSLog(@"hello world");
        
        NSTimer *time = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:time forMode:(NSDefaultRunLoopMode)];

        [[NSRunLoop currentRunLoop] run];
        
    }];
    
    [thead start];
    
    
}

- (void)timerClick {
    
    static int index = 0 ;
    index ++ ;
    NSLog(@"开始timer了");
    
}

- (void)printSelf {
    
    NSLog(@"打印我zi'ji");
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
