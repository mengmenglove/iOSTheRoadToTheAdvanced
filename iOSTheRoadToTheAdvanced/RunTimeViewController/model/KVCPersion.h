//
//  Persion.h
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2017/12/28.
//  Copyright © 2017年 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVCPersion : NSObject <NSCoding, NSSecureCoding>

@property(nonatomic,strong)NSString   *name;
@property(nonatomic,assign)NSInteger  age;

@end
