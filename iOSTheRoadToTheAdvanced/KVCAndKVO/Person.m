//
//  Person.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 17/12/23.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "Person.h"

@implementation Person


- (instancetype)init {
    if (self = [super init]) {
        _name = @"_name";
        _isName = @"_isName";
        name = @"name";
        isName = @"isName";
        dog = [[Dog alloc] init];
        age = 20;
    }
    return self;
}

//设置value的时候异常
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

//设置空的时候处理
- (void)setNilValueForKey:(NSString *)key {

}

//异常处理
- (id)valueForUndefinedKey:(NSString *)key {

    return nil;
}



+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

//- (NSArray *)countOfName {
//
//    return @[@1,@1,@1];
//    
//}
//
//- (id)objectInNameAtIndex:(NSInteger) index {
//    return @1;
//}

//- (NSString *)getName {
//    return @"name_baoxian";
//}


-(void)des {
    NSLog(@"\n_name:%@\n_isName:%@\nname:%@\nisName:%@", _name,_isName,name,isName);

}



@end
