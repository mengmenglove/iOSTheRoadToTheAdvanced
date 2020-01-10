//
//  MasonryActionItem.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/10.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MasonryActionItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
