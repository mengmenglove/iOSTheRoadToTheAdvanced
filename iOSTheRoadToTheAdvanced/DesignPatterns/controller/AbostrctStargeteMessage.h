//
//  AbostrctStargeteMessage.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2018/3/8.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbostrctStargeteMessage : NSObject

+ (AbostrctStargeteMessage *)instance;

- (void)emptMessageHandle:(NSArray *)array;

@end
