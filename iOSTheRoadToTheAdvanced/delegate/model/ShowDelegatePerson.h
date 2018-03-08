//
//  ShowDelegatePerson.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/8.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ShowDelegatePerson;


@protocol  PersonDelegate

- (void)runPerson:(ShowDelegatePerson *)person Speed:(NSInteger)speed;

@end



@interface ShowDelegatePerson : NSObject
@property (nonatomic,assign) id<PersonDelegate>  delegate;

- (void)run;
@end
