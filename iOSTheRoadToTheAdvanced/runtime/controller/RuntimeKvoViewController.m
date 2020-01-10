//
//  RuntimeKvoViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/28.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "RuntimeKvoViewController.h"
#import <objc/runtime.h>

@interface RuntimeKvoViewController ()

@property (nonatomic, strong) NSString *name;
@end

@implementation RuntimeKvoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSLog(@"viewDidLoad class info: %@",object_getClass(self));
    
    [self addObserver:self.name forKeyPath:@"userName" options:nil context:nil];
    
    NSLog(@"viewDidLoad class info: %@",object_getClass(self));
    
    
    
    // Do any additional setup after loading the view.
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
