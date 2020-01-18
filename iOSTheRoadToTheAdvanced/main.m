//
//  main.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2017/12/21.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"app start");
        int result = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        NSLog(@"app end");
        
        return result;
    }
}
