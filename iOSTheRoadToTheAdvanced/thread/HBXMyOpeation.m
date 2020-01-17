//
//  HBXMyOpeation.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2020/1/18.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "HBXMyOpeation.h"

@implementation HBXMyOpeation

- (void)main {
     if (!self.isCancelled) {
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"task -%@", [NSThread currentThread]);
            }
        }

}
@end
