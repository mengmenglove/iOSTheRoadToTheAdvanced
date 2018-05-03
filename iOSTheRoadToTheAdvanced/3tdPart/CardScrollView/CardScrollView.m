//
//  CardScrollView.m
//  GCCardViewController
//
//  Created by 宫城 on 16/5/31.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "CardScrollView.h"
#import "UIView+helper.h"
#define IS_IPHONESMALLSCREEN  (([[UIScreen mainScreen] bounds].size.width-320)? NO:YES)

@interface CardScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, assign) NSInteger totalNumberOfCards;
@property (nonatomic, assign) NSInteger startCardIndex;
@property (nonatomic, assign) NSInteger currentCardIndex;


@property (nonatomic, strong) UIPageControl* pageControl;

@end

@implementation CardScrollView

#pragma mark - initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];

    [self addObserver:self forKeyPath:@"totalNumberOfCards" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"currentCardIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    self.cards = [NSMutableArray array];
    self.startCardIndex = 0;
    self.totalNumberOfCards = 0;
    self.currentCardIndex = 0;
    self.canDeleteCard = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pageControl.bottom = self.scrollView.bottom - 22;
}

- (void)dealloc {
   
    [self removeObserver:self forKeyPath:@"totalNumberOfCards"];
    [self removeObserver:self forKeyPath:@"currentCardIndex"];
}

#pragma mark - public methods

- (void)loadCard {
    for (UIView *card in self.cards) {
        [card removeFromSuperview];
    }
    
    self.totalNumberOfCards = [self.cardDataSource numberOfCards];
    if (self.totalNumberOfCards == 0) {
        return;
    }
    
    self.currentCardIndex = 0;
    
    [self.scrollView setContentSize:CGSizeMake((self.scrollView.width)*self.totalNumberOfCards, self.scrollView.height)];
    [self.scrollView setContentOffset:[self contentOffsetWithIndex:0]];
    
//    NSInteger count = self.totalNumberOfCards < 5 ? self.totalNumberOfCards : 5;
    
    for (NSInteger index = 0; index < self.totalNumberOfCards; index++) {
        UIView *card = [self.cardDataSource cardReuseView:nil atIndex:index];
//        card.center = [self centerForCardWithIndex:index];
        card.centerX = [self centerXForCardWithIndex:index];
        card.tag = index;
        [self.scrollView addSubview:card];
        [self.cards addObject:card];
        
        if (self.canDeleteCard) {
            UIPanGestureRecognizer *deleteGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCard:)];
            deleteGesture.minimumNumberOfTouches = 1;
            deleteGesture.maximumNumberOfTouches = 1;
            deleteGesture.delegate = self;
            [card addGestureRecognizer:deleteGesture];
        }
        
        [self.cardDelegate updateCard:card withProgress:1 direction:CardMoveDirectionNone];
    }
}

- (NSArray *)allCards {
    return self.cards;
}

- (NSInteger)currentCard {
    return self.currentCardIndex;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"totalNumberOfCards"]) {
        NSNumber* count = [change objectForKey:NSKeyValueChangeNewKey];
        self.pageControl.numberOfPages = count.integerValue;
    }
    else if ([keyPath isEqualToString:@"currentCardIndex"]) {
        NSNumber* index = [change objectForKey:NSKeyValueChangeNewKey];
        self.pageControl.currentPage = index.integerValue;
    }
}

#pragma mark - private methods

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    self.currentCardIndex = index;
    [self.scrollView setContentOffset:[self contentOffsetWithIndex:index] animated:animated];
}

- (CGPoint)centerForCardWithIndex:(NSInteger)index {
    return CGPointMake(self.scrollView.width*(index + 0.5), self.scrollView.center.y);
}

- (CGFloat)centerXForCardWithIndex:(NSInteger)index {
    return self.scrollView.width*(index + 0.5);
}

- (CGPoint)contentOffsetWithIndex:(NSInteger)index {
    CGPoint point = CGPointMake((self.scrollView.width)*index, 0);
    return point;
}

- (NSInteger)indexMapperTag:(NSInteger)tag {
    for (NSInteger index = 0; index < self.cards.count; index++) {
        UIView *card = [self.cards objectAtIndex:index];
        if (card.tag == tag) {
            return index;
            break;
        }
    }
    return 0;
}

- (void)reloadCardWithIndex:(NSInteger)index {
    [self reuseDeleteCardWithIndex:index];
    if (index == 3) {
        self.currentCardIndex-=1;
    }
    self.totalNumberOfCards-=1;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.width*self.totalNumberOfCards, self.scrollView.height)];
        for (UIView *card in self.cards) {
            [self.cardDelegate updateCard:card withProgress:1 direction:CardMoveDirectionNone];
        }
    }];
}

- (void)deleteCard:(UIPanGestureRecognizer *)gesture {
    CGPoint translatedPoint = [gesture translationInView:gesture.view];
    CGPoint cardCenter = CGPointMake(gesture.view.center.x, self.scrollView.height/2);
    CGFloat progress = fabs(translatedPoint.y/(self.scrollView.height/2));
    if (gesture.state == UIGestureRecognizerStateChanged) {
        cardCenter.y+=translatedPoint.y;
        [gesture.view setCenter:cardCenter];
        gesture.view.layer.opacity = 1 - 0.2*progress;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [gesture velocityInView:gesture.view];
        if ((translatedPoint.y < 0 && progress >= 1.0) || (translatedPoint.y < 0 && fabs(velocity.y) > 500)) {
            [UIView animateWithDuration:0.3 animations:^{
                [gesture.view setCenter:CGPointMake(gesture.view.center.x, -self.scrollView.height/2)];
            } completion:^(BOOL finished) {
                [self reloadCardWithIndex:[self indexMapperTag:gesture.view.tag]];
                [self.cardDataSource deleteCardWithIndex:gesture.view.tag];
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [gesture.view setCenter:cardCenter];
                gesture.view.layer.opacity = 1.0;
            }];
        }
    }
}

- (void)removeCard:(NSInteger)index onComplete:(CardsClearHandler)block {
    if (index < 0 && index > self.cards.count - 1) {
        return;
    }
    UIView* card = [self.cards objectAtIndex:index];
    [UIView animateWithDuration:0.3 animations:^{
        [card setCenter:CGPointMake(card.center.x, -self.scrollView.height/2)];
    } completion:^(BOOL finished) {
        [self reloadCardWithIndex:[self indexMapperTag:card.tag]];
        [self.cardDataSource deleteCardWithIndex:card.tag];
        if (block && self.cards.count <= 0) {
            block();
        }
    }];
}


- (void)reuseCardWithMoveDirection:(CardMoveDirection)moveDirection {
    BOOL isLeft = moveDirection == CardMoveDirectionLeft;
    UIView *card = nil;
    if (isLeft) {
        if (self.currentCardIndex > self.totalNumberOfCards - 3 || self.currentCardIndex < 2) {
            return;
        }
        card = [self.cards objectAtIndex:0];
        card.tag+=4;
    } else {
        if (self.currentCardIndex > self.totalNumberOfCards - 4 ||
            self.currentCardIndex < 1) {
            return;
        }
        card = [self.cards objectAtIndex:3];
        card.tag-=4;
    }
//    card.center = [self centerForCardWithIndex:card.tag];
    card.centerX = [self centerXForCardWithIndex:card.tag];
    [self.cardDataSource cardReuseView:card atIndex:card.tag];
    [self ascendingSortCards];
}

- (void)reuseDeleteCardWithIndex:(NSInteger)index {
    if (self.totalNumberOfCards <= 5) {
        [(UIView *)[self.cards objectAtIndex:index] removeFromSuperview];
        [self resetTagFromIndex:index];
        [self.cards removeObjectAtIndex:index];
        [self ascendingSortCards];
        return;
    }
    
    UIView *card = [self.cards objectAtIndex:index];
    NSInteger fromIndex = index;
    if (index == 0) {
        card.tag+=4;
        fromIndex = index - 1;
    } else if (index == 3) {
        card.tag-=4;
    } else {
        NSInteger lastTag = ((UIView *)[self.cards lastObject]).tag;
        NSInteger firstTag = ((UIView *)[self.cards firstObject]).tag;
        if (lastTag == self.totalNumberOfCards - 1) {
            card.tag = firstTag - 1;
        } else {
            card.tag = lastTag + 1;
            fromIndex = index - 1;
        }
    }
//    card.center = [self centerForCardWithIndex:card.tag];
    card.centerX = [self centerXForCardWithIndex:card.tag];
    [self ascendingSortCards];
    [self resetTagFromIndex:fromIndex];
//    [self.cardDataSource cardReuseView:card atIndex:card.tag];
}

- (void)resetTagFromIndex:(NSInteger)index {
    [self.cards enumerateObjectsUsingBlock:^(UIView *card, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((NSInteger)idx > index) {
            card.tag-=1;
            [UIView animateWithDuration:0.3 animations:^{
//                card.center = [self centerForCardWithIndex:card.tag];
                card.centerX = [self centerXForCardWithIndex:card.tag];
            }];
        }
    }];
}

- (void)ascendingSortCards {
    [self.cards sortUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        return obj1.tag > obj2.tag;
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        CGPoint translatedPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
//        if (fabs(translatedPoint.y) > fabs(translatedPoint.x)) {
//            return YES;
//        }
//    }
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat orginContentOffset = self.currentCardIndex*self.scrollView.width;
    
    CGFloat diff = scrollView.contentOffset.x - orginContentOffset;
    CGFloat progress = fabs(diff)/(self.scrollView.width*0.8);

    CardMoveDirection direction = diff > 0 ? CardMoveDirectionLeft : CardMoveDirectionRight;
    for (UIView *card in self.cards) {
        [self.cardDelegate updateCard:card withProgress:progress direction:direction];
    }
    
    CGFloat targetWidth = self.scrollView.width*0.6;
    
    if (fabs(diff) >= targetWidth) {
        self.currentCardIndex = direction == CardMoveDirectionLeft ? self.currentCardIndex + 1 : self.currentCardIndex - 1;
//        [self reuseCardWithMoveDirection:direction];
    }
}

- (UIPageControl *)pageControl {
	if(_pageControl == nil) {
		_pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPage = 0;
        _pageControl.layer.borderColor = [UIColor greenColor].CGColor;
        _pageControl.layer.borderWidth = 2.0;
	}
	return _pageControl;
}

- (UIScrollView *)scrollView {
	if(_scrollView == nil) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(41, 0, [UIScreen mainScreen].bounds.size.width - 82.0, 212)];
       
        CGFloat scrWidth =  [UIScreen mainScreen].bounds.size.width - 80;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, scrWidth, 212)];
        
//        if (IS_IPHONESMALLSCREEN) {
//             CGFloat scrWidth =  [UIScreen mainScreen].bounds.size.width - 80;
//            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 0, scrWidth, 212)];
//        }else {
//            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/5 - 15, 0, [UIScreen mainScreen].bounds.size.width*3/5 + 30, 212)];
//        }
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
//        _scrollView.layer.borderColor = [UIColor brownColor].CGColor;
//        _scrollView.layer.borderWidth = 2.0;
	}
	return _scrollView;
}

@end
