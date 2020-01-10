//
//  HBXHook.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/8.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "HBXHook.h"
#import <objc/runtime.h>

@implementation HBXHook

+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    
    Class getClass = classObject;
    Method fromMethod = class_getInstanceMethod(getClass, fromSelector);
    Method toMethod = class_getInstanceMethod(getClass, toSelector);
    
    if (class_addMethod(getClass, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        class_replaceMethod(classObject, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    }else {
        method_exchangeImplementations(fromMethod, toMethod);
    }
    
}

@end
