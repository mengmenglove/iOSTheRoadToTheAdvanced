//
//  ShowImageCell.h
//  LDTXDEMO
//
//  Created by 罗东 on 2018/1/16.
//  Copyright © 2018年 LuoDong. All rights reserved.
//  gitHub:https://github.com/TonyDongDong/CollectionView.git
//


#import <UIKit/UIKit.h>

@interface ShowImageCell : UICollectionViewCell
{
    UIImageView *imageView ;
    UILabel *titleLabel;
}
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@end
