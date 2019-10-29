//
//  HBXVIResourceLoader.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/10/19.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "HBXVIResourceLoader.h"
#import "HBXVIMediaCacheWorker.h"

@interface HBXVIResourceLoader ()

@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong) HBXVIMediaCacheWorker *cacheWorker;


@end

@implementation HBXVIResourceLoader

- (instancetype)initWithURL:(NSURL *)url {
    if (self =  [super init]) {
        _url = url;
        _cacheWorker = [[HBXVIMediaCacheWorker alloc] initWithURL:url];
    }
    return self;
}


@end
