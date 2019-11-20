//
//  HBXVideoModel.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/10/12.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "HBXVideoModel.h"
#define KVIDEOLIST @"KVIDEOLIST"
@implementation HBXVideoModel

+ (HBXVideoModel *)initWithParam:(NSDictionary *)dict {
    if (dict) {
        HBXVideoModel *model = [[HBXVideoModel alloc] init];
        model.marPro = [dict[@"progress"] longLongValue];
        model.url = dict[@"url"];
    }
    return nil;
}

+ (NSArray *)getVideoList {
    NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:KVIDEOLIST];
    if (list) {
        return list;
    }
    return [NSArray array];
}

+ (void)deleteWithUrl:(NSString *)url {
    if (url && url.length > 0) {
        NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:KVIDEOLIST];
        NSMutableArray *newList = [NSMutableArray array];
        if (list) {
            [newList addObjectsFromArray:list];
        }
        for (NSDictionary *dict in newList) {
            if ([dict[@"url"] isEqualToString:url]) {
                [newList removeObject:dict];
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:newList forKey:KVIDEOLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)addNewDownLoadWithUrl:(NSString *)url {
    if (url && url.length > 0) {
        NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:KVIDEOLIST];
        NSMutableArray *newList = [NSMutableArray array];
        if (list) {
            [newList addObjectsFromArray:list];
        }
        NSDictionary *dict = @{@"url":url};
        [newList addObject:dict];
        
        [[NSUserDefaults standardUserDefaults] setObject:newList forKey:KVIDEOLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



+ (NSArray *)getVideoKeyList:(NSString *)key {
    NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:[HBXVideoModel getSystemKey:key]];
    if (list) {
        return list;
    }
    return [NSArray array];
    
}
+ (void)addNewDownLoadWithUrl:(NSString *)url key:(NSString *)key {
    if (url && url.length > 0) {
        NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:[HBXVideoModel getSystemKey:key]];
        NSMutableArray *newList = [NSMutableArray array];
        if (list) {
            [newList addObjectsFromArray:list];
        }
        NSDictionary *dict = @{@"url":url};
        [newList addObject:dict];
        
        [[NSUserDefaults standardUserDefaults] setObject:newList forKey:[HBXVideoModel getSystemKey:key]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


+ (NSString *)getSystemKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@%@",KVIDEOLIST,key];
}

@end
