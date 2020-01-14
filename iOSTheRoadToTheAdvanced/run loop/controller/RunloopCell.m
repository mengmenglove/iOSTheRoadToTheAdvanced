//
//  RunloopCell.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 2020/1/14.
//  Copyright © 2020 黄保贤. All rights reserved.
//

#import "RunloopCell.h"

@interface RunloopCell ()

@property(nonatomic,strong)UIView  *container;
@property(nonatomic,assign)CGFloat  screenWidth;
@end

@implementation RunloopCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        [self creatSubView];
    }
    return self;
}






- (void)creatSubView {
    
    [self.contentView addSubview:self.container];
    self.container.frame = CGRectMake(10, 15, self.screenWidth, 120);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateDetailImages {
    if (self.container.subviews.count > 0) {
        [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    CGFloat viewWidth = (self.screenWidth - 20)/3;
    
    for (int i = 0 ; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth * i + 10, 0, viewWidth - 20, 120)];
        [self.container addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"show_image"];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}

@end
