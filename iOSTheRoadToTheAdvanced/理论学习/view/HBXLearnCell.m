//
//  HBXLearnCell.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/4/16.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import "HBXLearnCell.h"

@interface HBXLearnCell ()

@property (nonatomic, strong) UILabel *showLabel;

@end

@implementation HBXLearnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.showLabel];
    }
    return self;
}
- (void)updateInfo:(NSString *)text {
    self.showLabel.text = text;
}


+ (CGFloat)sizeToCellWithText:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    CGRect rect =  [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 10000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return rect.size.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    rect.size.width -= 30;
    rect.origin.x = 15;
    self.showLabel.frame = rect;
}

- (UILabel *)showLabel {
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] init];
        _showLabel.textColor = [UIColor blackColor];
        _showLabel.font = [UIFont systemFontOfSize:14.0];
        _showLabel.numberOfLines = 0;
    }
    return _showLabel;
}

@end
