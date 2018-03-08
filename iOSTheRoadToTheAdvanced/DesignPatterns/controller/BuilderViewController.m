//
//  BuilderViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/8.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "BuilderViewController.h"
#import "Dorector.h"
#import "ConcreatBuild.h"


@interface BuilderViewController ()

@end

@implementation BuilderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建生产者， 知道要做的产品
    ConcreatBuild *build = [[ConcreatBuild alloc] init];
    
    
    //创建承包商
    
    Dorector *docter = [[Dorector alloc] initWithBuilder:build];
    
    
    //交付产品
   NSString *produceStr =  [docter construct];
    
    
    // Do any additional setup after loading the view.
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
