//
//  FirstVCCollectionViewCell.h
//  ACPanAbleCollectionViewCellExample
//
//  Created by ac_mba on 15/8/16.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "ACPanAbleCollectionViewCell.h"


typedef NS_ENUM(NSUInteger, FirstVCCVCellActionOptions) {
    FirstVCCVCellActionOptions_more = 0,
    FirstVCCVCellActionOptions_delete = 1
};


@protocol FirstVCCVCellActionDelegate <NSObject>

@optional
- (void)collectionView:(UICollectionView *)collectionView didTapMoreActionButtonAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView didTapDeleteActionButtonAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface FirstVCCollectionViewCell : ACPanAbleCollectionViewCell

@property (nonatomic, weak) id<FirstVCCVCellActionDelegate> actionDelegate;

+ (CGFloat)heightForCellByIndexPath:(NSIndexPath *)indexPath;

- (void)configCellByTitleTextString:(NSString *)titleTextString
                      actionOptions:(NSArray *)actionOptions;

@end
