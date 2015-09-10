//
//  ACPACVCActionView.m
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "ACPACVCActionView.h"
#import "ACPACVCActionItem.h"

@interface ACPACVCActionView ()

@property (nonatomic, strong) NSArray                       *actionItemsArray;

@end


@implementation ACPACVCActionView

#pragma mark - Init

- (instancetype)initWithActionItemsArray:(NSArray *)actionItemsArray {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        [self pac_initializeWithActionItemsArray:actionItemsArray];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithActionItemsArray:nil];
}

- (id)init {
    return [self initWithActionItemsArray:nil];
}

#pragma mark - Public

- (CGFloat)actionViewWidth {
    CGFloat actionViewWidth = 0.0;
    for (NSInteger i = 0; i < self.actionItemsArray.count; i++) {
        ACPACVCActionItem *actionItemView = self.actionItemsArray[i];
        if ([self.actionItemsOptionsIndexArray containsObject:@(i)]) {
            actionViewWidth += actionItemView.itemWidth;
        }
    }
    return actionViewWidth;
}

- (CGFloat)requireDxForOpenActionView {
    CGFloat halfOfAverageItemWidth = (([self actionViewWidth] / self.actionItemsOptionsIndexArray.count) / 2.0);
    return halfOfAverageItemWidth;
}

#pragma mark - View

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.actionItemsArray && self.actionItemsArray.count > 0) {
        CGFloat actionItemViewX = 0.0;
        for (NSInteger i = 0; i < self.actionItemsArray.count; i++) {
            ACPACVCActionItem *actionItemView = self.actionItemsArray[i];
            CGFloat actionItemViewWidth = 0.0;
            if ([self.actionItemsOptionsIndexArray containsObject:@(i)]) {
                actionItemViewWidth = actionItemView.itemWidth;
            }
            actionItemView.frame = CGRectMake(actionItemViewX,
                                              0.0,
                                              actionItemViewWidth,
                                              self.bounds.size.height);
            if ([self.actionItemsOptionsIndexArray containsObject:@(i)]) {
                actionItemViewX += actionItemView.itemWidth;
            }
        }
    }
}

#pragma mark - Private

- (void)pac_initializeWithActionItemsArray:(NSArray *)actionItemsArray {
    if (actionItemsArray && actionItemsArray.count > 0) {
        self.actionItemsArray = actionItemsArray;
        NSMutableArray *actionItemsOptionsIndexMArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.actionItemsArray.count; i++) {
            ACPACVCActionItem *actionItemView = self.actionItemsArray[i];
            [self addSubview:actionItemView];
            
            [actionItemsOptionsIndexMArray addObject:@(i)];
        }
        self.actionItemsOptionsIndexArray = actionItemsOptionsIndexMArray;
    }
}


@end
