//
//  RuntimeController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/26.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "RuntimeController.h"
#import <objc/runtime.h>
#import "ZJExtensionActionModel.h"

@interface mPersion: NSObject

@end

@implementation mPersion

- (void)foo {
    NSLog(@"mPersion  fooToo");
}

@end


@interface RuntimeController ()

@end

@implementation RuntimeController



//第一步截获方法实现
//resolveInstanceMethod 获取新的实现方法
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


/*
 //第二步，修改实现方法的对象
 forwardingTargetForSelector的实现，重新获取新对象执行方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(foo)];
}
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES;
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(foo)) {
        return [mPersion new];
    }
    return [super forwardingTargetForSelector:aSelector];
}
*/




- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(foo)];
    
    
    NSDictionary *param = @{@"name":@"huang", @"version":@"1.0.0"};
    ZJExtensionActionModel *model = [[ZJExtensionActionModel alloc] initWithParam:param];
    NSLog(@"model.name: %@ model.version: %@",model.name,model.version);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return [super resolveInstanceMethod:sel];
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"foo"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
        //具体参数文档定义      //https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    }
    return [super methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;

    mPersion  *p = [mPersion new];
    if ([p respondsToSelector:sel]) {
        NSLog(@"ready forwardInvocation");
        [anInvocation invokeWithTarget:p];
    }else {
        [self doesNotRecognizeSelector:sel];
    }
    
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
