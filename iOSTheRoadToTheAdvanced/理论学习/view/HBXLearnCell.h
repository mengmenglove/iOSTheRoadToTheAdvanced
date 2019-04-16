//
//  HBXLearnCell.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/4/16.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBXLearnCell : UITableViewCell

- (void)updateInfo:(NSString *)text;
+ (CGFloat)sizeToCellWithText:(NSString *)text ;
@end

NS_ASSUME_NONNULL_END
