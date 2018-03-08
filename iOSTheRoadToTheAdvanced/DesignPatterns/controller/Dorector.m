//
//  Dorector.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/8.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "Dorector.h"


@interface Dorector()

@property (nonatomic,copy) id<Build>  builder;

@end

@implementation Dorector


- (instancetype)initWithBuilder:(id<Build>)build {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)construct {
    //创建邮件
    return [self.builder buildPart];
}



@end
