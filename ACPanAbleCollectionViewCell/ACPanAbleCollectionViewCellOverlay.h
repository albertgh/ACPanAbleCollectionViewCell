//
//  ACPanAbleCollectionViewCellOverlay.h
//  ACPanAbleCollectionViewCellExample
//
//  Created by Albert Chu on 15/8/18.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACPanAbleCollectionViewCell;

@interface ACPanAbleCollectionViewCellOverlay : UIView

@property (nonatomic, weak) ACPanAbleCollectionViewCell *ownerCell;

@end
