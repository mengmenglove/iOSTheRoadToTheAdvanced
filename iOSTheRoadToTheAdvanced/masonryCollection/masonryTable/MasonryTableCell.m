//
//  MasonryTableCell.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2020/1/10.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "MasonryTableCell.h"
#import "MasonryActionItem.h"

@interface MasonryTableCell ()

@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MasonryTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView {
    self.namelabel = [[UILabel alloc] init];
    self.namelabel.numberOfLines = 0;
    [self.contentView addSubview:self.namelabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.namelabel.mas_bottom).offset(10);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];    
}

- (void)updateItem:(NSObject *)item {
    MasonryActionItem *t = (MasonryActionItem *)item;
    self.namelabel.text = t.name;
    self.contentLabel.text = t.content;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
