//
//  NSObject+BaoXianKVC.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 17/12/23.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BaoXianKVC)

- (void)baoxian_SetValue:(id)value forKey:(NSString *)key;
-(id)baoxian_valueForKeyPath:(NSString *)keyPath;


@end
