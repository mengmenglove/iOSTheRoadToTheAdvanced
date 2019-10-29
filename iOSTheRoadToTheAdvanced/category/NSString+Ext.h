//
//  NSString+Ext.h
//  RRSpring
//
//  Created by wong sam on 12-4-10.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLString)
-(BOOL) isEqualToURLString:(NSString *)urlString;
-(NSString *)md5;
- (NSString *)trim;
- (NSNumber*) stringToNumber;
@end
