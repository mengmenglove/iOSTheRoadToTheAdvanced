//
//  HBXHook.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/8.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBXHook : NSObject

+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;

@end

NS_ASSUME_NONNULL_END
