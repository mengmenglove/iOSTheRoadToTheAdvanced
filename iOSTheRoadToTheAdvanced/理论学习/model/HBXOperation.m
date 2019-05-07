//
//  HBXOperation.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/5/7.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "HBXOperation.h"

@implementation HBXOperation

- (void)main {
    
    if (self.isCancelled) {
        NSLog(@"canceled");
        return;
    }
    
    NSLog(@"start print %@ %@", self, [NSThread currentThread]);
    sleep(2);
    
    NSLog(@"end print %@", [NSThread currentThread]);
    
    
    
}




@end
