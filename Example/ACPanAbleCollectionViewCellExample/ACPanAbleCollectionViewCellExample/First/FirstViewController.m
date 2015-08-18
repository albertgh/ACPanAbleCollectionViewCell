//
//  FirstViewController.m
//  ACPanAbleCollectionViewCellExample
//
//  Created by ac_mba on 15/8/14.
//  Copyright (c) 2015年 ac. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstVCCollectionViewCell.h"

#import "TestPushViewController.h"


static NSString * const FirstVCCVCellIdentifier = @"FirstVCCVCellIdentifier";


@interface FirstViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate,
FirstVCCVCellActionDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *fakeDataMArray;

@end


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.fakeDataMArray = [[NSMutableArray alloc] init];
    
    [self initializeCollectionView];
    
    [self loadFakeData];
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
    
    UIEdgeInsets insets = UIEdgeInsetsMake(64.0,
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat paddingLeftRight = 0.0;
    CGFloat cellWidth = (collectionView.bounds.size.width - (paddingLeftRight * 2)); // left & right space

    NSNumber *itemNumber = self.fakeDataMArray[indexPath.row];
    CGFloat  cellHeight = [FirstVCCollectionViewCell heightForCellByItemNumber:itemNumber];
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fakeDataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FirstVCCollectionViewCell *cell =
    (FirstVCCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FirstVCCVCellIdentifier
                                                                           forIndexPath:indexPath];
    
    // config cell
    cell.actionDelegate = self;
    
    NSNumber *itemNumber = self.fakeDataMArray[indexPath.row];
    NSString *fakeTitleString = [NSString stringWithFormat:@"title - %@", itemNumber];
    NSString *titleString = fakeTitleString;
    NSArray *actionOptions = @[@(FirstVCCVCellActionOptions_delete)];
    if ([itemNumber integerValue] % 2 == 0) {
        actionOptions = @[@(FirstVCCVCellActionOptions_more), @(FirstVCCVCellActionOptions_delete)];
    }
    [cell configCellByTitleTextString:titleString actionOptions:actionOptions];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath: %@", indexPath);
    
    TestPushViewController *testVC = [[TestPushViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark - FirstVCCVCellActionDelegate

- (void)collectionView:(UICollectionView *)collectionView didTapMoreActionButtonAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didTapMoreActionButtonAtIndexPath: %@", indexPath);
    
    ACPanAbleCollectionViewCell *cell =
    (ACPanAbleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell pac_hideRightActionView];
}

- (void)collectionView:(UICollectionView *)collectionView didTapDeleteActionButtonAtIndexPath:(NSIndexPath *)indexPath {
    //[self closeCurrentOpenedActionView];
    NSLog(@"didTapDeleteActionButtonAtIndexPath: %@", indexPath);
    
    [self.fakeDataMArray removeObjectAtIndex:indexPath.row];
    __weak __typeof(self)weakSelf = self;
    [self.collectionView
     performBatchUpdates:^{
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
     }
     completion:^(BOOL finished) {
         
     }];
}

#pragma mark - fake data

- (void)loadFakeData {
    for (NSInteger i = 0; i < 12; i++) {
        [self.fakeDataMArray addObject:@(i)];
    }
}

@end
