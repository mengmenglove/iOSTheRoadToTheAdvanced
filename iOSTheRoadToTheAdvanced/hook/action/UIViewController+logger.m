//
//  UIViewController+logger.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/8.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "UIViewController+logger.h"
#import "HBXHook.h"


@implementation UIViewController (logger)

+ (void)load {
    
    
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        SEL fromSelectorAppear = @selector(viewWillAppear:);
        SEL toSelectorAppear = @selector(hook_viewWillApper:);
        [HBXHook hookClass:[self class] fromSelector:fromSelectorAppear toSelector:toSelectorAppear];
        
        
        SEL fromSelectorDisAppear = @selector(viewWillDisappear:);
        SEL toSelectorDisAppear = @selector(hook_viewWillDisApper:);
        
        [HBXHook hookClass:self fromSelector:fromSelectorDisAppear toSelector:toSelectorDisAppear];
                
    });
    
}


- (void)hook_viewWillApper:(BOOL)animated {
    [self insertToViewApper];
}

- (void)hook_viewWillDisApper:(BOOL)animated {
    [self insertToViewWillDisApper];
}

- (void)insertToViewApper {
    
    NSLog(@"insertToViewApper: %@",NSStringFromClass([self class]));
}

- (void)insertToViewWillDisApper {
    NSLog(@"insertToViewWillDisApper: %@",NSStringFromClass([self class]));
}


@end
