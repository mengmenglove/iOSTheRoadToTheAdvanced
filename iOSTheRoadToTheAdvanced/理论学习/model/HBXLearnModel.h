//
//  HBXLearnModel.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/4/16.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBXLearnModel : NSObject

@property (nonatomic, assign)  CGFloat cellHeight;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString *text;

- (instancetype)initWith:(NSString *)name age:(int)age;

@end

NS_ASSUME_NONNULL_END
