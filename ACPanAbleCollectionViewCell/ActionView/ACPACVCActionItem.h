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

- (void)configItemWithActionBlock:(void (^)(void))actionBlock
                       textString:(NSString *)textString;


@end
