//
//  ShowImageCell.m
//  LDTXDEMO
//
//  Created by 罗东 on 2018/1/16.
//  Copyright © 2018年 LuoDong. All rights reserved.
//  gitHub:https://github.com/TonyDongDong/CollectionView.git
//


#import "ShowImageCell.h"

@implementation ShowImageCell
@synthesize imageView;
@synthesize titleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:titleLabel];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    imageView.frame = self.contentView.bounds;
    titleLabel.frame = CGRectMake(0.0f,0.0f , self.contentView.bounds.size.width, 44.0f);

}
@end
