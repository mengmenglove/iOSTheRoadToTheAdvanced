//
//  HBXVideoModel.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/10/12.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBXVideoModel : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) long long marPro;

+ (HBXVideoModel *)initWithParam:(NSDictionary *)dict;

+ (NSArray *)getVideoList;
+ (void)addNewDownLoadWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
