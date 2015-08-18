//
//  ACPanAbleCollectionViewCell.m
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "ACPanAbleCollectionViewCell.h"
#import "ACPanAbleCollectionViewCellOverlay.h"


@interface ACPanAbleCollectionViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) ACPACVCActionView                         *leftActionView;
@property (nonatomic, assign) CGFloat                                   leftActionViewYOffset;
@property (nonatomic, assign, readonly) BOOL                            isClosingLeftActionView;

@property (nonatomic, strong) ACPACVCActionView                         *rightActionView;
@property (nonatomic, assign) CGFloat                                   rightActionViewYOffset;
@property (nonatomic, assign, readonly) BOOL                            isClosingRightActionView;

@property (nonatomic, strong) UIPanGestureRecognizer                    *panGestureRecognizer;
@property (nonatomic, assign) CGPoint                                   gestureBeganPoint;

@property (nonatomic, strong) ACPanAbleCollectionViewCellOverlay        *overlay;

@end


@implementation ACPanAbleCollectionViewCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self pac_initializeCell];
    }
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self pac_removeOverlay];
}

#pragma mark - LayoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self pac_resetLeftActionViewLayout];
    [self pac_resetRightActionViewLayout];
}

#pragma mark - Reuse

- (void)prepareForReuse {
    [super prepareForReuse];
    
    //-- rest
    [self pac_removeOverlay];

    [self pac_cancelPanGesture];
    
    _isActionViewActiving = NO;
    
    _isLeftActionViewOpened = NO;
    _disableLeftActionView = YES;
    
    _isRightActionViewOpened = NO;
    _disableRightActionView = YES;
    
    self.userInteractionEnabled = YES;
    //----------------------------------------------------------------------------------------------//
    
    //-- contentView position
    self.contentView.frame = self.bounds;
    //----------------------------------------------------------------------------------------------//
}

#pragma mark - Left ActionView Methods

- (void)pac_addLeftActionView:(ACPACVCActionView *)leftActionView {
    [self pac_addLeftActionView:leftActionView withYOffset:0.0];
}

- (void)pac_addLeftActionView:(ACPACVCActionView *)leftActionView
                  withYOffset:(CGFloat)offset {
    [self.leftActionContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (leftActionView) {
        self.leftActionView = leftActionView;
        [self.leftActionContentView addSubview:self.leftActionView];
    }
    else {
        self.disableLeftActionView = YES;
    }
}

- (void)pac_updateLeftActionViewOptions:(NSArray *)options {
    if (self.leftActionView && !self.disableLeftActionView) {
        self.leftActionView.actionItemsOptionsIndexArray = options;
    }
    else {
        self.leftActionView.actionItemsOptionsIndexArray = @[];
    }
}

- (void)pac_resetLeftActionViewLayout {
    CGRect leftActionContentViewRect = CGRectMake(self.contentView.bounds.origin.x,
                                                  self.contentView.bounds.origin.y,
                                                  [self.leftActionView actionViewWidth],
                                                  self.contentView.bounds.size.height);
    self.leftActionContentView.frame = leftActionContentViewRect;

    CGFloat leftActionView_x = 0.0;
    CGFloat leftActionView_y = 0.0;
    CGFloat leftActionView_w = [self.leftActionView actionViewWidth];
    CGFloat leftActionView_h = self.contentView.bounds.size.height - self.leftActionViewYOffset;
    self.rightActionView.frame = CGRectMake(leftActionView_x,
                                            leftActionView_y,
                                            leftActionView_w,
                                            leftActionView_h);
    
    self.leftActionContentView.hidden = self.disableLeftActionView;
}

- (void)pac_showLeftActionView {
    if (!self.isLeftActionViewOpened && !self.isRightActionViewOpened && !self.disableLeftActionView) {
        self.userInteractionEnabled = NO;
        
        _isActionViewActiving = YES;
        
        //self.leftActionContentView.hidden = NO;
        //self.leftActionContentView.alpha = 1.0;
        
        [self.contentView bringSubviewToFront:self.leftActionContentView];
        [self pac_addOverlayOnCellCollectionView];

        [UIView animateWithDuration:ACPACVCell_ActionViewAnimationDuration
                              delay:0.0
             usingSpringWithDamping:ACPACVCell_ActionViewAnimationSpringDamping
              initialSpringVelocity:ACPACVCell_ActionViewAnimationSpringVelocity
                            options:ACPACVCell_ActionViewAnimationOptions
                         animations:^ {
                             CGRect contentViewFrame = self.bounds;
                             contentViewFrame.origin.x = self.leftActionContentView.bounds.size.width;
                             self.contentView.frame = contentViewFrame;
                         }
                         completion:^(BOOL finished) {
                             [self pac_didShowLeftActionView];
                             
                             self.userInteractionEnabled = YES;
                         }];
    }
}

- (void)pac_didShowLeftActionView {
    _isLeftActionViewOpened = YES;
    
    _isActionViewActiving = NO;
    
    [self pac_addOverlayOnCellCollectionView];

    if ([self.pacDelegate respondsToSelector:@selector(collectionView:didShowLeftActionViewAtIndexPath:)]) {
        [self.pacDelegate collectionView:[self currentCollectionView]
        didShowLeftActionViewAtIndexPath:[self currentIndexPath]];
    }
}

- (void)pac_restoreLeftActionViewOpenedState {
    self.userInteractionEnabled = NO;
    
    _isActionViewActiving = YES;
    
    //self.leftActionContentView.hidden = NO;
    //self.leftActionContentView.alpha = 1.0;
    [UIView animateWithDuration:ACPACVCell_ActionViewAnimationDuration
                          delay:0.0
         usingSpringWithDamping:ACPACVCell_ActionViewAnimationSpringDamping
          initialSpringVelocity:ACPACVCell_ActionViewAnimationSpringVelocity
                        options:ACPACVCell_ActionViewAnimationOptions
                     animations:^ {
                         CGRect contentViewFrame = self.bounds;
                         contentViewFrame.origin.x = self.leftActionContentView.bounds.size.width;
                         self.contentView.frame = contentViewFrame;
                     }
                     completion:^(BOOL finished) {
                         _isLeftActionViewOpened = YES;
                         
                         _isActionViewActiving = NO;
                         
                         self.userInteractionEnabled = YES;
                     }];
}

- (void)pac_hideLeftActionView {
    if (self.isClosingLeftActionView
        || self.contentView.frame.origin.x == 0.0) {
        return;
    }

    [self pac_removeOverlay];

    self.userInteractionEnabled = NO;
    
    _isActionViewActiving = YES;
    
    _isClosingLeftActionView = YES;
    
    [UIView animateWithDuration:ACPACVCell_ActionViewAnimationDuration
                          delay:0.0
         usingSpringWithDamping:ACPACVCell_ActionViewAnimationSpringDamping
          initialSpringVelocity:ACPACVCell_ActionViewAnimationSpringVelocity
                        options:ACPACVCell_ActionViewAnimationOptions
                     animations:^ {
                         self.contentView.frame = self.bounds;
                     }
                     completion:^(BOOL finished) {
                         //self.leftActionContentView.alpha = 0.0;
                         //self.leftActionContentView.hidden = YES;
                         _isLeftActionViewOpened = NO;
                         _isClosingLeftActionView = NO;
                         
                         _isActionViewActiving = NO;
                         
                         self.userInteractionEnabled = YES;
                     }];
}

#pragma mark - Right ActionView Methods

- (void)pac_addRightActionView:(ACPACVCActionView *)rightActionView {
    [self pac_addRightActionView:rightActionView withYOffset:0.0];
}

- (void)pac_addRightActionView:(ACPACVCActionView *)rightActionView
                   withYOffset:(CGFloat)offset {
    [self.rightActionContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.rightActionViewYOffset = offset;
    if (rightActionView) {
        self.rightActionView = rightActionView;
        [self.rightActionContentView addSubview:self.rightActionView];
    }
    else {
        self.disableRightActionView = YES;
    }
}

- (void)pac_updateRightActionViewOptions:(NSArray *)options {
    if (self.rightActionView && !self.disableRightActionView) {
        self.rightActionView.actionItemsOptionsIndexArray = options;
    }
    else {
        self.rightActionView.actionItemsOptionsIndexArray = @[];
    }
}

- (void)pac_resetRightActionViewLayout {
    CGFloat rightActionContentView_x = self.contentView.bounds.size.width - [self.rightActionView actionViewWidth];
    CGRect rightActionContentViewRect = CGRectMake(rightActionContentView_x,
                                                   self.contentView.bounds.origin.y,
                                                   [self.rightActionView actionViewWidth],
                                                   self.contentView.bounds.size.height);
    self.rightActionContentView.frame = rightActionContentViewRect;
    
    CGFloat rightActionView_x = 0.0;
    CGFloat rightActionView_y = 0.0;
    CGFloat rightActionView_w = [self.rightActionView actionViewWidth];
    CGFloat rightActionView_h = self.contentView.bounds.size.height - self.rightActionViewYOffset;
    self.rightActionView.frame = CGRectMake(rightActionView_x,
                                            rightActionView_y,
                                            rightActionView_w,
                                            rightActionView_h);
    
    self.rightActionContentView.hidden = self.disableRightActionView;
}

- (void)pac_showRightActionView {
    if (!self.isRightActionViewOpened && !self.isLeftActionViewOpened && !self.disableRightActionView) {
        self.userInteractionEnabled = NO;
        
        _isActionViewActiving = YES;
        
        //self.rightActionContentView.hidden = NO;
        //self.rightActionContentView.alpha = 1.0;
        
        [self.contentView bringSubviewToFront:self.rightActionContentView];
        [self pac_addOverlayOnCellCollectionView];

        [UIView animateWithDuration:ACPACVCell_ActionViewAnimationDuration
                              delay:0.0
             usingSpringWithDamping:ACPACVCell_ActionViewAnimationSpringDamping
              initialSpringVelocity:ACPACVCell_ActionViewAnimationSpringVelocity
                            options:ACPACVCell_ActionViewAnimationOptions
                         animations:^ {
                             CGRect contentViewFrame = self.bounds;
                             contentViewFrame.origin.x = -self.rightActionContentView.bounds.size.width;
                             self.contentView.frame = contentViewFrame;
                         }
                         completion:^(BOOL finished) {
                             [self pac_didShowRightActionView];
                             
                             self.userInteractionEnabled = YES;
                         }];
    }
}

- (void)pac_didShowRightActionView {
    _isRightActionViewOpened = YES;
    
    _isActionViewActiving = NO;
    
    [self pac_addOverlayOnCellCollectionView];
    
    if ([self.pacDelegate respondsToSelector:@selector(collectionView:didShowRightActionViewAtIndexPath:)]) {
        [self.pacDelegate collectionView:[self currentCollectionView]
       didShowRightActionViewAtIndexPath:[self currentIndexPath]];
    }
}

- (void)pac_restoreRightActionViewOpenedState {
    self.userInteractionEnabled = NO;
    
    _isActionViewActiving = YES;
    
    //self.rightActionContentView.hidden = NO;
    //self.rightActionContentView.alpha = 1.0;
    [UIView animateWithDuration:ACPACVCell_ActionViewAnimationDuration
                          delay:0.0
         usingSpringWithDamping:ACPACVCell_ActionViewAnimationSpringDamping
          initialSpringVelocity:ACPACVCell_ActionViewAnimationSpringVelocity
                        options:ACPACVCell_ActionViewAnimationOptions
                     animations:^ {
                         CGRect contentViewFrame = self.bounds;
                         contentViewFrame.origin.x = -self.rightActionContentView.bounds.size.width;
                         self.contentView.frame = contentViewFrame;
                     }
                     completion:^(BOOL finished) {
                         _isRightActionViewOpened = YES;
                         
                         _isActionViewActiving = NO;
                         
                         self.userInteractionEnabled = YES;
                     }];
}

- (void)pac_hideRightActionView {
    if (self.isClosingRightActionView
        || self.contentView.frame.origin.x == 0.0) {
        return;
    }

    [self pac_removeOverlay];

    self.userInteractionEnabled = NO;
    
    _isActionViewActiving = YES;
    
    _isClosingRightActionView = YES;
    
    [UIView animateWithDuration:ACPACVCell_ActionViewAnimationDuration
                          delay:0.0
         usingSpringWithDamping:ACPACVCell_ActionViewAnimationSpringDamping
          initialSpringVelocity:ACPACVCell_ActionViewAnimationSpringVelocity
                        options:ACPACVCell_ActionViewAnimationOptions
                     animations:^ {
                         self.contentView.frame = self.bounds;
                     }
                     completion:^(BOOL finished) {
                         //self.rightActionContentView.alpha = 0.0;
                         //self.rightActionContentView.hidden = YES;
                         _isRightActionViewOpened = NO;
                         _isClosingRightActionView = NO;
                         
                         _isActionViewActiving = NO;
                         
                         self.userInteractionEnabled = YES;
                     }];
}

#pragma mark - Initialization

- (void)pac_initializeCell {
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    // pan gesture
    self.panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pac_didPan:)];
    self.panGestureRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:self.panGestureRecognizer];
    
    // add action content view
    _leftActionContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.leftActionContentView.backgroundColor = [UIColor clearColor];
    self.leftActionContentView.clipsToBounds = YES;
    [self addSubview:self.leftActionContentView];
    [self sendSubviewToBack:self.leftActionContentView];
    self.disableLeftActionView = YES;
    //self.leftActionContentView.alpha = 0.0;
    //self.leftActionContentView.hidden = YES;
    
    _rightActionContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightActionContentView.backgroundColor = [UIColor clearColor];
    self.rightActionContentView.clipsToBounds = YES;
    [self addSubview:self.rightActionContentView];
    [self sendSubviewToBack:self.rightActionContentView];
    self.disableRightActionView = YES;
    //self.rightActionContentView.alpha = 0.0;
    //self.rightActionContentView.hidden = YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint translation = [self.panGestureRecognizer translationInView:self];
        if (fabs(translation.y) > fabs(translation.x)) {
            return NO; // user is scrolling vertically
        }
    }
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (gestureRecognizer == self.panGestureRecognizer){
//        if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
//            return YES;
//        }
//    }
//    return NO;
//}

#pragma mark - Pan Gesture

- (void)pac_didPan:(UIGestureRecognizer *)recognizer {
    // cancel other cells
    NSArray *visibleCells = [self currentCollectionView].visibleCells;
    for (UICollectionViewCell *cell in visibleCells) {
        if ([cell isKindOfClass:[ACPanAbleCollectionViewCell class]] && cell != self) {
            ACPanAbleCollectionViewCell *panAbleCell = (ACPanAbleCollectionViewCell *)cell;
            [panAbleCell pac_cancelPanGesture];
        }
    }
    
    // current cell
    if (recognizer == self.panGestureRecognizer) {
        _isActionViewActiving = YES;
        CGPoint currentPoint = [self.panGestureRecognizer translationInView:self.contentView]; // [self.panGestureRecognizer locationInView:self.contentView];
        
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan: {
                self.gestureBeganPoint = currentPoint;
                //NSLog(@"Pan Began at %@", NSStringFromCGPoint(self.gestureBeganPoint));
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat dx = currentPoint.x - self.gestureBeganPoint.x;
                //NSLog(@"dx: %f", dx);
                CGFloat cellContentViewNewXPosition = dx;
                if (dx > 0) {
                    // swipe to right
                    
                    // default max distance to move
                    if (dx > ACPACVCell_DistanceForCantMoveMoreHint) {
                        cellContentViewNewXPosition = ACPACVCell_DistanceForCantMoveMoreHint;
                    }
                    
                    if (!self.isLeftActionViewOpened
                        && !self.isRightActionViewOpened) {
                        if (!self.disableLeftActionView) {
                            //means want to show left action view
                            //self.leftActionContentView.hidden = NO;
                            //self.leftActionContentView.alpha = 1.0;
                            
                            [self.contentView bringSubviewToFront:self.leftActionContentView];
                            [self pac_addOverlayOnCellCollectionView];
                            
                            if (dx <= (self.leftActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint)) {
                                cellContentViewNewXPosition = dx;
                            }
                            else {
                                cellContentViewNewXPosition = (self.leftActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint);
                            }
                        }
                    }
                    else if (self.isLeftActionViewOpened) {
                        // for hint can't swipe more
                        cellContentViewNewXPosition += self.leftActionContentView.bounds.size.width;
                    }
                    else if (self.isRightActionViewOpened) {
                        // begin close right action view
                        if (dx < (self.rightActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint)) {
                            cellContentViewNewXPosition = -self.rightActionContentView.bounds.size.width + dx;
                        }
                        else {
                            cellContentViewNewXPosition = ACPACVCell_DistanceForCantMoveMoreHint;
                        }
                    }
                }
                else if (dx < 0) {
                    // swipe to left
                    
                    // default max distance to move
                    if (-dx > ACPACVCell_DistanceForCantMoveMoreHint) {
                        cellContentViewNewXPosition = -ACPACVCell_DistanceForCantMoveMoreHint;
                    }
                    
                    if (!self.isRightActionViewOpened
                        && !self.isLeftActionViewOpened) {
                        if (!self.disableRightActionView) {
                            //means want to show right action view
                            //self.rightActionContentView.hidden = NO;
                            //self.rightActionContentView.alpha = 1.0;
                            
                            [self.contentView bringSubviewToFront:self.rightActionContentView];
                            [self pac_addOverlayOnCellCollectionView];

                            if (-dx <= (self.rightActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint)) {
                                cellContentViewNewXPosition = dx;
                            }
                            else {
                                cellContentViewNewXPosition = -(self.rightActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint);
                            }
                        }
                    }
                    else if (self.isRightActionViewOpened) {
                        // for hint can't swipe more
                        cellContentViewNewXPosition += -self.rightActionContentView.bounds.size.width;
                    }
                    else if (self.isLeftActionViewOpened) {
                        // begin close left action view
                        if (-dx < (self.leftActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint)) {
                            cellContentViewNewXPosition = self.leftActionContentView.bounds.size.width + dx;
                        }
                        else {
                            cellContentViewNewXPosition = -ACPACVCell_DistanceForCantMoveMoreHint;
                        }
                    }
                }
                
                CGRect contentViewFrame = self.bounds;
                contentViewFrame.origin.x = cellContentViewNewXPosition;
                self.contentView.frame = contentViewFrame;
                
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                CGFloat dx = currentPoint.x - self.gestureBeganPoint.x;
                if (dx > 0) {
                    // swipe to right
                    // check left action view state
                    if (!self.isLeftActionViewOpened
                        && !self.isRightActionViewOpened) {
                        if (!self.disableLeftActionView) {
                            if (dx > [self.leftActionView requireDxForOpenActionView]) {
                                [self pac_showLeftActionView];
                            }
                            else if (dx >= self.leftActionContentView.bounds.size.width) {
                                [self pac_didShowLeftActionView];
                                if (dx >= (self.leftActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint)) {
                                    [self pac_restoreLeftActionViewOpenedState];
                                }
                            }
                            else {
                                [self pac_hideLeftActionView]; // moved distance not enough for open
                            }
                        }
                        else {
                            [self pac_hideLeftActionView]; // left action view disabled
                        }
                    }
                    else if (self.isLeftActionViewOpened) {
                        // restore left action view opened position
                        [self pac_restoreLeftActionViewOpenedState];
                    }
                    else if (self.isRightActionViewOpened) {
                        if (dx > (self.rightActionContentView.bounds.size.width / 3.0)) {
                            [self pac_hideRightActionView];
                        }
                        else {
                            [self pac_restoreRightActionViewOpenedState];
                        }
                    }
                }
                else if (dx < 0) {
                    // swipe to left
                    // check right action view state
                    if (!self.isRightActionViewOpened
                        && !self.isLeftActionViewOpened) {
                        if (!self.disableRightActionView) {
                            if (-dx > [self.rightActionView requireDxForOpenActionView]) {
                                [self pac_showRightActionView];
                            }
                            else if (-dx >= self.rightActionContentView.bounds.size.width) {
                                [self pac_didShowRightActionView];
                                if (-dx >= (self.rightActionContentView.bounds.size.width + ACPACVCell_DistanceForCantMoveMoreHint)) {
                                    [self pac_restoreRightActionViewOpenedState];
                                }
                            }
                            else {
                                [self pac_hideRightActionView]; // moved distance not enough for open
                            }
                        }
                        else {
                            [self pac_hideRightActionView]; // right action view disabled
                        }
                    }
                    else if (self.isRightActionViewOpened){
                        // restore right action view opened position
                        [self pac_restoreRightActionViewOpenedState];
                    }
                    else if (self.isLeftActionViewOpened) {
                        if (-dx > (self.leftActionContentView.bounds.size.width / 3.0)) {
                            [self pac_hideLeftActionView];
                        }
                        else {
                            [self pac_restoreLeftActionViewOpenedState];
                        }
                    }
                }
                break;
            }
                
            default:
                break;
        }
    }
}

#pragma mark -

- (BOOL)pac_isActionViewActiving {
    return self.isActionViewActiving;
}

- (void)pac_cancelPanGesture {
    if (self.panGestureRecognizer.state != UIGestureRecognizerStateEnded
        && self.panGestureRecognizer.state != UIGestureRecognizerStatePossible) {
        self.userInteractionEnabled = NO;
        
        self.panGestureRecognizer.enabled = NO;
        self.panGestureRecognizer.enabled = YES;
        
        _isActionViewActiving = YES;
        
        [UIView animateWithDuration:ACPACVCell_ActionViewAnimationDuration
                              delay:0.0
             usingSpringWithDamping:ACPACVCell_ActionViewAnimationSpringDamping
              initialSpringVelocity:ACPACVCell_ActionViewAnimationSpringVelocity
                            options:ACPACVCell_ActionViewAnimationOptions
                         animations:^ {
                             self.contentView.frame = self.bounds;
                         }
                         completion:^(BOOL finished) {
                             _isLeftActionViewOpened = NO;
                             _isClosingLeftActionView = NO;
                             _isRightActionViewOpened = NO;
                             _isClosingRightActionView = NO;
                             
                             _isActionViewActiving = NO;
                             
                             self.userInteractionEnabled = YES;
                         }];
        [self pac_removeOverlay];
    }
}

#pragma mark - Overlay

- (void)pac_addOverlayOnCellCollectionView {
    if (self.overlay) {
        return;
    }

    UICollectionView *collectionView = [self currentCollectionView];
    self.overlay = [[ACPanAbleCollectionViewCellOverlay alloc] initWithFrame:collectionView.bounds];
    self.overlay.ownerCell = self;
    
    [collectionView addSubview:self.overlay];
}

- (void)pac_removeOverlay {
    if (!self.overlay) {
        return;
    }
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

#pragma mark - Extensions

- (UICollectionView *)currentCollectionView {
    id view = [self superview];
    while (view && ![view isKindOfClass:[UICollectionView class]]) {
        view = [view superview];
    }
    UICollectionView *collectionView = (UICollectionView *)view;
    return collectionView;
}

- (NSIndexPath *)currentIndexPath {
    NSIndexPath *indexPath = [[self currentCollectionView] indexPathForCell:self];
    return indexPath;
}


@end
