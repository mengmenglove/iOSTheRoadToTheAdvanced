//
//  Person.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 17/12/23.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

@interface Person : NSObject
{
    NSString *_name;
    NSString * _isName;
    NSString * name;
    NSString * isName;
    Dog *dog;
    NSInteger age;
}




- (void)des;



@end
