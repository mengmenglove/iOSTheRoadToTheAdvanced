//
//  ZJImageSynthesusUtil.h
//  aizongjie
//
//  Created by huangbaoxian on 2018/6/11.
//  Copyright © 2018年 wennzg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJImageSynthesusUtil : NSObject

+ (void)createGroupAvatar:(NSArray *)imageArray finished:(void (^)(UIImage *groupAvatar))finished;

@end
