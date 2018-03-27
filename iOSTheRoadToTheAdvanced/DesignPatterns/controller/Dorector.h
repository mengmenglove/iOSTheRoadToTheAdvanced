//
//  Dorector.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/8.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Build.h"


@interface Dorector : NSObject

//创建闯入的实现者
- (instancetype)initWithBuilder:(id<Build>)build;

//建造
- (NSString *)construct;


@end
