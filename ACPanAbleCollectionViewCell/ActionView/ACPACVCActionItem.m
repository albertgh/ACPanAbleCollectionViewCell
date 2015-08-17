//
//  ACPACVCActionItem.m
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "ACPACVCActionItem.h"


typedef void (^ACPACVCAIActionBlock)(void);

static CGFloat const ACPACVCActionView_DefaultItemWidth     = 54.0;

static CGFloat const ACPACVCActionView_ButtonTextFontSize   = 16.0;


@interface ACPACVCActionItem ()

@property (copy)                ACPACVCAIActionBlock        actionBlock;

@property (nonatomic, strong)   UIButton                    *actionButton;

@end


@implementation ACPACVCActionItem

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self pac_initialize];
    }
    return self;
}

#pragma mark - Public

- (void)configItemWithActionBlock:(void (^)(void))actionBlock
                       textString:(NSString *)textString {
    self.actionBlock = actionBlock;
    [self.actionButton setTitle:textString forState:UIControlStateNormal];
}

#pragma mark - Views

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.actionButton.frame = self.bounds;
}

#pragma mark - Action

- (void)triggerAction {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark - Private

- (void)pac_initialize {
    self.itemWidth = ACPACVCActionView_DefaultItemWidth;
    
    //-- action button
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.actionButton addTarget:self
                          action:@selector(triggerAction)
                forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionButton];
    
    // style
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:ACPACVCActionView_ButtonTextFontSize];
    //----------------------------------------------------------------------------------------------//
}


@end
