//
//  ACPACVCActionView.h
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPACVCActionView : UIView

@property (nonatomic, strong) NSArray *actionItemsOptionsIndexArray;

- (id)initWithActionItemsArray:(NSArray *)actionItemsArray;
- (id)initWithFrame:(CGRect)frame __deprecated_msg("Method deprecated. Use `initWithActionItemsArray:`");
- (id)init __deprecated_msg("Method deprecated. Use `initWithActionItemsArray:`");

- (CGFloat)actionViewWidth;
- (CGFloat)requireDxForOpenActionView;

@end
