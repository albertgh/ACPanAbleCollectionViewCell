//
//  ACPanAbleCollectionViewCellOverlay.m
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/18.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "ACPanAbleCollectionViewCellOverlay.h"
#import "ACPanAbleCollectionViewCell.h"

@implementation ACPanAbleCollectionViewCellOverlay

#pragma mark - Dealloc

- (void)dealloc {
    [self.ownerCell currentCollectionView].userInteractionEnabled = YES;
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

#pragma mark - Hit Test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.ownerCell) {
        //-- check left action view
        if (self.ownerCell.leftActionContentView
            && CGRectContainsPoint(self.ownerCell.leftActionContentView.bounds,
                                   [self convertPoint:point toView:self.ownerCell.leftActionContentView])) {
                return nil;
            }
        //----------------------------------------------------------------------------------------------//
        
        //-- check right action view
        if (self.ownerCell.rightActionContentView
            && CGRectContainsPoint(self.ownerCell.rightActionContentView.bounds,
                                   [self convertPoint:point toView:self.ownerCell.rightActionContentView])) {
                return nil;
            }
        //----------------------------------------------------------------------------------------------//
        
        [self.ownerCell pac_restoreAllActionViewClosedState];

        /** this is not elegant
        //-- disable touches if action view is activing
        if (self.ownerCell.isActionViewActiving
            && [self.ownerCell currentCollectionView].userInteractionEnabled) {
            [self.ownerCell currentCollectionView].userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ACPACVCell_ActionViewAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.ownerCell currentCollectionView].userInteractionEnabled = YES;
            });
        }
        //----------------------------------------------------------------------------------------------//
         */
    }
    return self;
}


@end
