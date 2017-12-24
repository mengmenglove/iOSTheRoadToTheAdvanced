//
//  Dog.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 17/12/23.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (instancetype)init {
    
    if (self = [super init]) {
        _age = 10;
    }
    return self;
}

- (NSInteger)getAge {
    return 100;
}

@end
