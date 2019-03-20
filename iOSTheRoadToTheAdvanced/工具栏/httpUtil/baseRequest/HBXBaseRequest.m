//
//  HBXBaseRequest.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/12/8.
//  Copyright © 2018 黄保贤. All rights reserved.
//

#import "HBXBaseRequest.h"

@interface HBXBaseRequest ()
{
    NSString *_url;
}


@end

@implementation HBXBaseRequest


- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/api.php";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"url": _url,
             @"format": @"json"
             };
}


@end
