//
//  RuntimeController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/26.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "RuntimeController.h"
#import <objc/runtime.h>


@interface mPersion: NSObject

- (void)fooToo;

@end

@implementation mPersion

- (void)fooToo {
    NSLog(@"mPersion  fooToo");
}

@end


@interface RuntimeController ()

@end

@implementation RuntimeController




//resolveInstanceMethod 实现
/*

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self performSelector:@selector(foo:)];
    // Do any additional setup after loading the view.
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(foo:)) {
        class_addMethod([self class], sel, fooMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void fooMethod(id obj, SEL _cmd) {
    NSLog(@"new foo");
    
}
*/



- (void)viewDidLoad {
    [super viewDidLoad];
    
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(foo:)) {
        return [mPersion new];
    }
    return [super forwardingTargetForSelector:aSelector];
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
