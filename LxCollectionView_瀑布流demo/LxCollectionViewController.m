//
//  ViewController.m
//  LxCollectionWaterfallFlow
//
//  Created by admin on 15/8/10.
//  Copyright (c) 2015年 YinLong. All rights reserved.
//

#import "LxCollectionViewController.h"
#import "LxCollectionWaterFallFlow.h"
#import "LxCollectionWaterFallCell.h"

static CGFloat const kMargin = 10.f;
static NSString * const reuseIdentifier = @"LxCollectionWaterFallCell";

@interface LxCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LxCollectionWaterFallFlow *layout;

@end

@implementation LxCollectionViewController

#pragma mark init methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                             collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LxCollectionWaterFallCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (LxCollectionWaterFallFlow *)layout {
    if (!_layout) {
        _layout = [[LxCollectionWaterFallFlow alloc] init];
        _layout.minimumInteritemSpacing = kMargin;
        _layout.minimumLineSpacing = kMargin;
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _layout;
}

#pragma mark -
#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LxCollectionWaterFallFlow";
    self.dataList = [NSMutableArray array];

    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 2*kMargin)/3.f;
    for (NSUInteger idx = 0; idx < 100; idx ++) {
        CGFloat height = 100 + (arc4random() % 100);
        NSValue *value = [NSValue valueWithCGSize:CGSizeMake(width, height)];
        [_dataList addObject:value];
    }
    
    [self.view addSubview:self.collectionView];
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxCollectionWaterFallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
                                  reuseIdentifier forIndexPath:indexPath];

    cell.label.text = [NSString stringWithFormat:@"%zi", indexPath.row];
    cell.label.frame = cell.bounds;

    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [[_dataList objectAtIndex:indexPath.row] CGSizeValue];
    
    return  size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 2*kMargin)/3.f;
    for (NSUInteger idx = 0; idx < 50; idx ++) {
        CGFloat height = 100 + (arc4random() % 100);
        NSValue *value = [NSValue valueWithCGSize:CGSizeMake(width, height)];
        [_dataList addObject:value];
    }
    
    [self.collectionView reloadData];
}

@end
