//
//  ACPanAbleCollectionViewCell.h
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPACVCActionItem.h"
#import "ACPACVCActionView.h"

@protocol ACPanAbleCollectionViewCellDelegate <NSObject>

@optional
- (void)collectionView:(UICollectionView *)collectionView didShowLeftActionViewAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView didShowRightActionViewAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ACPanAbleCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <ACPanAbleCollectionViewCellDelegate>    pacDelegate;


//-- Left Action View
#pragma mark - Left Action View

@property (nonatomic, assign) BOOL                                      disableLeftActionView;
@property (nonatomic, assign, readonly) BOOL                            isLeftActionViewOpened;


/**
 * Add customize leftActionView
 * @param leftActionView : customize leftActionView (the width should be bigger then 44.0 and a little smaller than super view's width)
 * @return void
 */
- (void)pac_addLeftActionView:(ACPACVCActionView *)leftActionView;
- (void)pac_addLeftActionView:(ACPACVCActionView *)leftActionView
                  withYOffset:(CGFloat)offset;

- (void)pac_showLeftActionView;
- (void)pac_hideLeftActionView;

- (void)pac_updateLeftActionViewOptions:(NSArray *)options;
//--------------------------------------------------------------------------------------------------//


//-- Right Action View
#pragma mark - Right Action View

@property (nonatomic, assign) BOOL                                      disableRightActionView;
@property (nonatomic, assign, readonly) BOOL                            isRightActionViewOpened;


/**
 * Add customize rightActionView
 * @param rightActionView : customize rightActionView (the width should be bigger then 44.0 and a little smaller than super view's width)
 * @return void
 */
- (void)pac_addRightActionView:(ACPACVCActionView *)rightActionView;
- (void)pac_addRightActionView:(ACPACVCActionView *)rightActionView
                   withYOffset:(CGFloat)offset;

- (void)pac_showRightActionView;
- (void)pac_hideRightActionView;

- (void)pac_updateRightActionViewOptions:(NSArray *)options;
//--------------------------------------------------------------------------------------------------//


- (BOOL)pac_isActionViewActiving;
- (void)pac_cancelPanGesture;


@end
