//
//  NSObject+BaoXianKVC.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 17/12/23.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import "NSObject+BaoXianKVC.h"
#import <objc/runtime.h>
@implementation NSObject (BaoXianKVC)


- (void)baoxian_SetValue:(id)value forKey:(NSString *)key {
    if (!key || key.length == 0)  {//可以合法
        return;
    }
    if ([value isKindOfClass:[NSNull class]])  {
        [self setNilValueForKey:key];
        return;
    }
    
    if (![value isKindOfClass:[NSObject class]]) {
        NSException *ex = [NSException exceptionWithName:@"huangbaoxna" reason:@"asda" userInfo:nil];
        @throw ex;
    }
    
    // 调用属性类型设置值 变量成员变量类型
    
    
    NSString *funkName = [NSString stringWithFormat:@"set%@", key.capitalizedString];
    
    if ([self respondsToSelector:@selector(funkName)]) {
        [self performSelector:@selector(funkName ) withObject:value];
    }
    
    
    
    if (![self.class accessInstanceVariablesDirectly]) {
        NSException *ex = [NSException exceptionWithName:@"huangbaoxna" reason:@"asda" userInfo:nil];
        @throw ex;
    }
    
    //访问成员变量
    unsigned int count = 0;
    
  Ivar *iv =   class_copyIvarList([self class], &count);
    
    Ivar ivar1 = iv[0];
    
    for (int i = 0; i < count; i++) {
        Ivar v = iv[i];
        
        NSString *name = [NSString stringWithFormat:@"%s",ivar_getName(v)];
        
        NSLog(@"property:%s", ivar_getName(v));
        
        if ([name isEqualToString:[NSString stringWithFormat:@"_%@",key]]) {
            object_setIvar(self, v, value);
            break;
        }
        //依次判断 _isKey  key _isKey
        
    }
    NSLog(@"count is %d  iv %s",count, ivar_getName(ivar1));
    
    [self setValue:value forUndefinedKey:key];
    
}

@end
