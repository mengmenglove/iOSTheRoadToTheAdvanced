//
//  MethosSwizzViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/27.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "MethosSwizzViewController.h"
#import <objc/runtime.h>
@interface MethosSwizzViewController ()

@end

@implementation MethosSwizzViewController

+ (void)initialize {
    NSLog(@"MethosSwizzViewController initialize");
}

+ (void)load {
     NSLog(@"MethosSwizzViewController load");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        SEL originSelecotor = @selector(viewDidLoad);
        SEL newSelector = @selector(hbxViewDidLoad);
        
        Method originMethod = class_getInstanceMethod(class, originSelecotor);
        Method newMethod = class_getInstanceMethod(class, newSelector);
        
        BOOL didAddMethod = class_addMethod(class, originSelecotor, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (didAddMethod) {
            class_replaceMethod(class, newSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
            NSLog(@"didAddMethod yes");
        }else {
            method_exchangeImplementations(originMethod, newMethod);
            NSLog(@"didAddMethod NO");
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"origin viewdidLoad");
    // Do any additional setup after loading the view.
}

- (void)hbxViewDidLoad {
    [self hbxViewDidLoad];
    
    NSLog(@"hbxViewDidLoad");

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
