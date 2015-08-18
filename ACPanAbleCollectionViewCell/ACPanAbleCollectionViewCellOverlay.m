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

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    
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
        if (self.ownerCell.isLeftActionViewOpened) {
            [self.ownerCell pac_hideLeftActionView];
        }
        //----------------------------------------------------------------------------------------------//
        
        //-- check right action view
        if (self.ownerCell.rightActionContentView
            && CGRectContainsPoint(self.ownerCell.rightActionContentView.bounds,
                                   [self convertPoint:point toView:self.ownerCell.rightActionContentView])) {
                return nil;
            }
        if (self.ownerCell.isRightActionViewOpened) {
            [self.ownerCell pac_hideRightActionView];
        }
        //----------------------------------------------------------------------------------------------//
    }
    return self;
}


@end
