//
//  ZJExtensionActionModel.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/29.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJExtensionActionModel : NSObject
- (instancetype)initWithParam:(NSDictionary *)param ;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *version;
@end

NS_ASSUME_NONNULL_END
