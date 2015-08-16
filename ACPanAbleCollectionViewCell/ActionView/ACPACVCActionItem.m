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

static CGFloat const ACPACVCActionView_IconWidth            = 22.0;
static CGFloat const ACPACVCActionView_IconHeight           = 22.0;
static CGFloat const ACPACVCActionView_IconMarginLabel      = 5.0;

static CGFloat const ACPACVCActionView_LabelHeight          = 22.0;


@interface ACPACVCActionItem ()

@property (copy) ACPACVCAIActionBlock                       actionBlock;

@property (nonatomic, strong) UIView                        *containerView;
@property (nonatomic, strong) UIImageView                   *iconImageView;
@property (nonatomic, strong) UILabel                       *textLabel;
@property (nonatomic, assign) CGFloat                       containerViewHeight;

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
    [self configItemWithActionBlock:actionBlock textString:textString iconImageName:nil];
}

- (void)configItemWithActionBlock:(void (^)(void))actionBlock
                    iconImageName:(NSString *)iconImageName {
    [self configItemWithActionBlock:actionBlock textString:nil iconImageName:iconImageName];
}

- (void)configItemWithActionBlock:(void (^)(void))actionBlock
                       textString:(NSString *)textString
                    iconImageName:(NSString *)iconImageName {
    self.actionBlock = actionBlock;
    
    BOOL haveText = textString && textString.length > 0;
    if (haveText) {
        self.textLabel.text = textString;
    }
    
    BOOL haveIconImage = iconImageName && iconImageName.length >0 && [UIImage imageNamed:iconImageName];
    if (haveIconImage) {
        self.iconImageView.image = [UIImage imageNamed:iconImageName];
    }
    
    if (!haveText && !haveIconImage) {
        self.textLabel.text = @"!";
        NSLog(@"must have one of them");
    }
}

#pragma mark - Views

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //-- update contentView frame
    CGRect containerViewFrame = self.bounds;
    containerViewFrame.size.height = self.containerViewHeight;
    self.containerView.frame = containerViewFrame;
    CGPoint containerViewCenter = CGPointMake((self.bounds.size.width / 2.0),
                                              (self.bounds.size.height / 2.0));
    self.containerView.center = containerViewCenter;
    //----------------------------------------------------------------------------------------------//
    
    
    //-- iconImageView frame
    CGFloat iconImageViewX = ((self.bounds.size.width - ACPACVCActionView_IconWidth) / 2.0);
    CGRect iconImageViewFrame = CGRectMake(iconImageViewX,
                                           0.0,
                                           ACPACVCActionView_IconWidth,
                                           ACPACVCActionView_IconHeight);
    //----------------------------------------------------------------------------------------------//

    //-- textLabel frame
    CGRect textLabelFrame = CGRectMake(0.0,
                                       ACPACVCActionView_IconHeight + ACPACVCActionView_IconMarginLabel,
                                       self.bounds.size.width,
                                       ACPACVCActionView_LabelHeight);
    //----------------------------------------------------------------------------------------------//
    
    BOOL haveIconImage = self.iconImageView.image;
    BOOL haveText = self.textLabel.text && self.textLabel.text.length > 0;
    
    if (haveIconImage && haveText) {
        //NSLog(@"use above frame value");
    }
    else if (haveIconImage && !haveText) {
        iconImageViewFrame.origin.y = ((self.bounds.size.height - ACPACVCActionView_IconHeight) / 2.0);
        textLabelFrame = CGRectZero;
    }
    else if (!haveIconImage && haveText) {
        iconImageViewFrame = CGRectZero;
        textLabelFrame.origin.y = ((self.containerViewHeight - ACPACVCActionView_LabelHeight) / 2.0);
    }

    self.iconImageView.frame = iconImageViewFrame;
    self.textLabel.frame = textLabelFrame;

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
    
    //-- containerView
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.containerView];
    
    self.containerViewHeight = ACPACVCActionView_IconHeight + ACPACVCActionView_IconMarginLabel + ACPACVCActionView_LabelHeight;
    //----------------------------------------------------------------------------------------------//

    //-- iconImageView
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.containerView addSubview:self.iconImageView];
    //----------------------------------------------------------------------------------------------//

    //-- text label
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:12.0];
    [self.containerView addSubview:self.textLabel];
    //----------------------------------------------------------------------------------------------//
    
    
    //-- add tapGestureRecognizer
    self.containerView.userInteractionEnabled = NO;
    self.iconImageView.userInteractionEnabled = NO;
    self.textLabel.userInteractionEnabled = NO;

    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(triggerAction)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    //----------------------------------------------------------------------------------------------//
}


@end
