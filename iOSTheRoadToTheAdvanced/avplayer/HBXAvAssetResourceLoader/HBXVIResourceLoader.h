//
//  HBXVIResourceLoader.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/10/19.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBXVIResourceLoader : NSObject

@property (nonatomic, strong, readonly) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
