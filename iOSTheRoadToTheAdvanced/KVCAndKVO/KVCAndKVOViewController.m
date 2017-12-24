//
//  KVCAndKVOViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 17/12/23.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "KVCAndKVOViewController.h"
#import "Person.h"
#import "NSObject+BaoXianKVC.h"

@interface KVCAndKVOViewController ()

@end

@implementation KVCAndKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Person *p = [[Person alloc] init];
   
    
    [p baoxian_SetValue:@"shuzhen" forKey:@"name"];

    
}

- (void)demo3 {
    Person *p = [[Person alloc] init];
    
    [p setValue:@"huangbaoxian" forKey:@"name"];
    
    [p des];
}


- (void)demo2 {
    Person *p = [[Person alloc] init];
    
    
    id dog = [p valueForKey:@"dog"];
    id age = [p valueForKey:@"age"];
    
    NSLog(@"dog is %@  age is  %@",dog,age);
    
    
    
    id newage =   [p valueForKeyPath:@"dog.age"];
    
    NSLog(@"newage is %@",newage);

}


- (void)demo1 {
    
    Person *p = [[Person alloc] init];
    
    id name = [p valueForKey:@"name"];
    
    NSLog(@"name is %@", name);


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
