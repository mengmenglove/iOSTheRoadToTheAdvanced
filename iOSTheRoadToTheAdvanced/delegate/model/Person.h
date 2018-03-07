//
//  Person.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/7.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@protocol  PersonDelegate

- (void)runPerson:(Person *)person Speed:(NSInteger)speed;

@end

@interface Person : NSObject

@property (nonatomic,assign) id<PersonDelegate>  delegate;

- (void)run;

@end
