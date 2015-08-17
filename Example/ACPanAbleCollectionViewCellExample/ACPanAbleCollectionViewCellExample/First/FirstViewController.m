//
//  FirstViewController.m
//  ACPanAbleCollectionViewCellExample
//
//  Created by ac_mba on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "FirstViewController.h"

#import "FirstVCCollectionViewCell.h"


static NSString * const FirstVCCVCellIdentifier = @"FirstVCCVCellIdentifier";


@interface FirstViewController ()
<UIScrollViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegate,
FirstVCCVCellActionDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self initializeCollectionView];
}

- (void)initializeCollectionView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.footerReferenceSize = CGSizeZero;
    layout.headerReferenceSize = CGSizeZero;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 1.0;
    
    self.collectionView =
    [[UICollectionView alloc] initWithFrame:self.view.bounds
                                collectionViewLayout:layout];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0,
                                           0.0,
                                           49.0,
                                           0.0);
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
    
    [self.view addSubview:self.collectionView];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;


    
    // config
    self.collectionView.backgroundColor = [UIColor lightGrayColor];

    self.collectionView.alwaysBounceVertical = YES;

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = YES;
    
    [self.collectionView registerClass:[FirstVCCollectionViewCell class]
            forCellWithReuseIdentifier:FirstVCCVCellIdentifier];
}

#pragma mark - Close current opened mark as read action view

- (void)closeCurrentOpenedActionView {
    // need to make this behaviour more elegant, some hitTest: way mabye
    NSArray *visibleCells = self.collectionView.visibleCells;
    for (UICollectionViewCell *cell in visibleCells) {
        if ([cell isKindOfClass:[ACPanAbleCollectionViewCell class]]) {
            ACPanAbleCollectionViewCell *panAbleCell = (ACPanAbleCollectionViewCell *)cell;
            [panAbleCell pac_hideLeftActionView];
            [panAbleCell pac_hideRightActionView];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self closeCurrentOpenedActionView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat paddingLeftRight = 0.0;
    CGFloat cellWidth = (collectionView.bounds.size.width - (paddingLeftRight * 2)); // left & right space

    CGFloat  cellHeight = [FirstVCCollectionViewCell heightForCellByIndexPath:indexPath];
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FirstVCCollectionViewCell *cell =
    (FirstVCCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FirstVCCVCellIdentifier
                                                                           forIndexPath:indexPath];
    
    // config cell
    cell.actionDelegate = self;
    NSString *titleString = [NSString stringWithFormat:@"section: %@- row:%@", @(indexPath.section), @(indexPath.row)];
    NSArray *actionOptions = @[@(FirstVCCVCellActionOptions_delete)];
    if (indexPath.row % 2 == 0) {
        actionOptions = @[@(FirstVCCVCellActionOptions_more), @(FirstVCCVCellActionOptions_delete)];
    }
    [cell configCellByTitleTextString:titleString actionOptions:actionOptions];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self closeCurrentOpenedActionView];
    NSLog(@"didSelectItemAtIndexPath: %@", indexPath);
}

#pragma mark - FirstVCCVCellActionDelegate

- (void)collectionView:(UICollectionView *)collectionView didTapMoreActionButtonAtIndexPath:(NSIndexPath *)indexPath {
    [self closeCurrentOpenedActionView];
    NSLog(@"didTapMoreActionButtonAtIndexPath: %@", indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView didTapDeleteActionButtonAtIndexPath:(NSIndexPath *)indexPath {
    [self closeCurrentOpenedActionView];
    NSLog(@"didTapDeleteActionButtonAtIndexPath: %@", indexPath);
}


@end
