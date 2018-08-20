//
//  CollectSilderViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by 黄保贤 on 18/3/27.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "CollectSilderViewController.h"
#import "LineLayout.h"
#import "LineCollectionViewCell.h"

#define W [UIScreen mainScreen].bounds.size.width
@interface CollectSilderViewController () <UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *lineCollectionView;
@end
static NSString  * const cellID = @"cellid";
@implementation CollectSilderViewController

- (UICollectionView *)lineCollectionView{
    if (_lineCollectionView == nil) {
        LineLayout *layout = [[LineLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(75, W/2 - 150/2, 75, W/2 - 150/2);
        _lineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, 300) collectionViewLayout:layout];
        _lineCollectionView.dataSource = self;
        [_lineCollectionView registerClass:[LineCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _lineCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.lineCollectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}

@end
