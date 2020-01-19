//
//  ZJPropertyViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/19.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "ZJPropertyViewController.h"
#import <objc/runtime.h>


@interface ZJPropertyViewController ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSMutableArray *propertyArray;

@end

@implementation ZJPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *attbutes = [NSMutableArray array];
    
    unsigned int outCount = 1;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0 ; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSLog(@"propertyName: %@", propertyName);
        
        NSString *value = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSLog(@"value: %@",value);
        
    }    
    free(properties);
        
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
