//
//  ACPACVCActionItem.h
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPACVCActionItem : UIView

@property (nonatomic, assign) CGFloat                       itemWidth;
@property (nonatomic, assign) CGFloat                       iconMarginLabel;


- (void)configItemWithActionBlock:(void (^)(void))actionBlock
                       textString:(NSString *)textString;

- (void)configItemWithActionBlock:(void (^)(void))actionBlock
                    iconImageName:(NSString *)iconImageName;

- (void)configItemWithActionBlock:(void (^)(void))actionBlock
                       textString:(NSString *)textString
                    iconImageName:(NSString *)iconImageName;


@end
