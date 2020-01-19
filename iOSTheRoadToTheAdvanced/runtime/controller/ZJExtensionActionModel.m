//
//  ZJExtensionActionModel.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/11/29.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "ZJExtensionActionModel.h"
#import <objc/runtime.h>

@implementation ZJExtensionActionModel


- (instancetype)initWithParam:(NSDictionary *)param {
    if (self = [super init]) {
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *attbutes = [NSMutableArray array];
        /*
         */
        
        unsigned int outCount;
        
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0 ; i < outCount; i++) {
            objc_property_t properity = properties[i];
            NSString *propertyName = [NSString stringWithCString:property_getName(properity) encoding:NSUTF8StringEncoding] ;
            [keys addObject:propertyName];
            
            NSString *values = [NSString stringWithCString:property_getAttributes(properity) encoding:NSUTF8StringEncoding];
            [attbutes addObject:values];
        }
        free(properties);
        
        for (NSString *k in keys) {
            if ( [param valueForKey:k] == nil)continue;
            [self setValue:[param valueForKey:k] forKey:k];
        }
        
    }
    return self;
}

@end
