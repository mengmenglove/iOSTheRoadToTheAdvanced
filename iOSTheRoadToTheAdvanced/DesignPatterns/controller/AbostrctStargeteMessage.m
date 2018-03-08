//
//  AbostrctStargeteMessage.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/8.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "AbostrctStargeteMessage.h"

static AbostrctStargeteMessage *manager;

@implementation AbostrctStargeteMessage

+ (AbostrctStargeteMessage *)instance {
    if (manager == nil) {
        manager = [[AbostrctStargeteMessage alloc] init];
    }
    return manager;
}


- (void)emptMessageHandle:(NSArray *)array {
    
    
}

@end
