//
//  HBXLearnModel.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/4/16.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "HBXLearnModel.h"

@implementation HBXLearnModel

- (instancetype)initWith:(NSString *)name age:(int)age {
    if (self = [super init]) {
        self.name = name;
        self.age = age;
    }
    return self;
}

@end
