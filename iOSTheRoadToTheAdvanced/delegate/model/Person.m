//
//  Person.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/7.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>



@implementation Person


/*
 在这个地方动态添加方法
 */
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(run)) {
        class_addMethod(self, sel,  (IMP)newRun, "v@:");
        return YES;
    }
    
    return [super resolveClassMethod:sel];
}
//IMP 函数指针 代码块
void newRun(id self,SEL  _cmd){
    NSLog(@"run is ok ");
}

/**
 * 消息转发重定向
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    //如果没有实现run 方法
    // 这个地方返回一个实现run方法的对象
    //
    //return [[Person alloc] init];
    
    return  [super forwardingTargetForSelector:aSelector];
}


/*
 * 生成方法签名
 */

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    
}


/*
 *  拿到方法签名 配发消息
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    
}



@end
