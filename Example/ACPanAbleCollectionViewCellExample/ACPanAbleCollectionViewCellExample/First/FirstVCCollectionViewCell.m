//
//  FirstVCCollectionViewCell.m
//  ACPanAbleCollectionViewCellExample
//
//  Created by ac_mba on 15/8/16.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "FirstVCCollectionViewCell.h"

@interface FirstVCCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) ACPACVCActionView *actionView;

@end


@implementation FirstVCCollectionViewCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self ac_initialize];
    }
    return self;
}

#pragma mark - LayoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = self.contentView.bounds;
}

#pragma mark - Reuse

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

#pragma mark - Highlight

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - Public

+ (CGFloat)heightForCellByIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForCell = 0.0;
    
    if (indexPath.row % 2 == 0) {
        heightForCell = 90.0;
    }
    else {
        heightForCell = 50.0;
    }
    
    return heightForCell;
}

- (void)configCellByTitleTextString:(NSString *)titleTextString
                      actionOptions:(NSArray *)actionOptions {
    self.titleLabel.text = titleTextString;
    
    self.disableRightActionView = NO;
    [self pac_updateRightActionViewOptions:actionOptions];
}

#pragma mark - Private

- (void)ac_initialize {
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    // title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    [self createCellRightActionView];
}

- (void)createCellRightActionView {

    NSMutableArray *actionItemsMArray = [[NSMutableArray alloc] init];
    
    __weak __typeof(self)weakSelf = self;
    ACPACVCActionItem *moreActionItem =
    [[ACPACVCActionItem alloc] initWithFrame:CGRectZero];
    moreActionItem.backgroundColor = [UIColor blueColor];
    moreActionItem.itemWidth = 80.0;
    [moreActionItem configItemWithActionBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([strongSelf.actionDelegate respondsToSelector:@selector(collectionView:didTapMoreActionButtonAtIndexPath:)]) {
            UICollectionView *collectionView = [strongSelf pac_onSuperCollectionView];
            NSIndexPath *indexPath = [collectionView indexPathForCell:strongSelf];
            [strongSelf.actionDelegate collectionView:collectionView
                    didTapMoreActionButtonAtIndexPath:indexPath];
        }
    } textString:@"more"];
    [actionItemsMArray addObject:moreActionItem];
    
    ACPACVCActionItem *deleteActionItem =
    [[ACPACVCActionItem alloc] initWithFrame:CGRectZero];
    deleteActionItem.backgroundColor = [UIColor redColor];
    deleteActionItem.itemWidth = 60.0;
    [deleteActionItem configItemWithActionBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([strongSelf.actionDelegate respondsToSelector:@selector(collectionView:didTapMoreActionButtonAtIndexPath:)]) {
            UICollectionView *collectionView = [strongSelf pac_onSuperCollectionView];
            NSIndexPath *indexPath = [collectionView indexPathForCell:strongSelf];
            [strongSelf.actionDelegate collectionView:collectionView
                    didTapMoreActionButtonAtIndexPath:indexPath];
        }
    } textString:@"delete"];
    [actionItemsMArray addObject:deleteActionItem];

    self.actionView =
    [[ACPACVCActionView alloc] initWithActionItemsArray:actionItemsMArray];
    
    [self pac_addRightActionView:self.actionView];
}

#pragma mark - Extensions

- (UICollectionView *)pac_onSuperCollectionView {
    id view = [self superview];
    while (view && ![view isKindOfClass:[UICollectionView class]]) {
        view = [view superview];
    }
    UICollectionView *collectionView = (UICollectionView *)view;
    return collectionView;
}


@end
