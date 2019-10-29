//
//  NSString+Ext.m
//  RRSpring
//
//  Created by wong sam on 12-4-10.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "NSString+Ext.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (URLString)
static NSArray* invalidSuffixes ;
+(void) initialize
{
    if (invalidSuffixes) {
        invalidSuffixes = nil;
    }
	invalidSuffixes = [[NSArray alloc] initWithObjects: @"#",
                       @"&",
                       @"?",
                       @"/",
                       nil];
}

- (BOOL) isEqualToURLString:(NSString *)urlString{
    if(urlString==nil){
        return NO;
    }
    NSString *lowSelf = [self lowercaseString];
    NSString *lowURL = [urlString lowercaseString];
    
    //只需要比较query之前的部分即可
    NSArray *lowSelfArray = [lowSelf componentsSeparatedByString:@"?"];
    lowSelf = [lowSelfArray objectAtIndex:0];
    NSArray *lowURLArray = [lowURL componentsSeparatedByString:@"?"];
    lowURL = [lowURLArray objectAtIndex:0];
    if(invalidSuffixes){
        for(NSString *suf in invalidSuffixes){
            if(suf&&[lowSelf hasSuffix:suf]){
                lowSelf = [lowSelf substringToIndex:([lowSelf length]-1)];
            }
            if(suf&&[lowURL hasSuffix:suf]){
                lowURL = [lowURL substringToIndex:([lowURL length]-1)];
            }
            
        }
    }
    return [lowURL isEqualToString:lowSelf];
}
- (NSString*) md5
{
	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    if(cStr)
    {
        CC_MD5( cStr, strlen(cStr), result );
        return [[NSString stringWithFormat:
                 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                 ] lowercaseString];
    }
    else {
        return nil;
    }
}
- (NSString *)trim {
    NSInteger len = [self length];
    if (len == 0) {
        return self;
    }
    const char *data = [self UTF8String];
    NSInteger start;
    for (start = 0; start < len && data[start] <= 32; ++start) {
        // just advance
    }
    NSInteger end;
    for (end = len - 1; end > start && data[end] <= 32; --end) {
        // just advance
    }
    return [self substringWithRange:NSMakeRange(start, end - start + 1)];
}
- (NSNumber*) stringToNumber
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [numberFormatter numberFromString:self];
//    [numberFormatter release];
    return number;
}
@end
