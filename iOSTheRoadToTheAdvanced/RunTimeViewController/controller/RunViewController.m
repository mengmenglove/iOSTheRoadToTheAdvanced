//
//  RunViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2017/12/28.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "RunViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#import "KVCPersion.h"

//clang -rewrite-objc
@interface RunViewController ()

@end

@implementation RunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    KVCPersion *p  = [[KVCPersion alloc] init];
    
    
   
}


- (void)save {
    
    KVCPersion *p = [[KVCPersion alloc] init];
    
    p.name = @"baoxian";
    p.age = 10;
    
    
    NSString *temp = NSTemporaryDirectory();
//    NSString *filePath =  [temp stringByAppendingPathComponent:@"baoxian"];
    
    
    
    
}

- (void)read {
    
    
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
