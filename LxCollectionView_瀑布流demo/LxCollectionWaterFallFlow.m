//
//  LxCollectionWaterfallFlow.m
//  LxCollectionWaterfallFlow
//
//  Created by admin on 15/8/10.
//  Copyright (c) 2015年 YinLong. All rights reserved.
//

#import "LxCollectionWaterFallFlow.h"

static NSUInteger const kColCount = 3;//列数

@interface LxCollectionWaterFallFlow ()

@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSMutableArray *colArr;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;

@end

@implementation LxCollectionWaterFallFlow

/**
 *(1)默认下该方法什么也不做,但在子类实现中,一般在该方法中设定一些必要的layout的结构和初始化需要的参数等
 */
- (void)prepareLayout {
    [super prepareLayout];
    // 获取总的个数
    NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (!itemCount) {
        return;
    }
    // 初始化
    self.attributes = [[NSMutableDictionary alloc] init];
    self.colArr = [NSMutableArray arrayWithCapacity:kColCount];
    self.delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    //_colArr 用来存放相邻的三个高度
    CGFloat top = .0f;
    for (NSUInteger idx = 0; idx < kColCount; idx ++) {
        [_colArr addObject:[NSNumber numberWithFloat:top]];
    }
    // 遍历所有的item，重新布局
    for (NSUInteger idx = 0; idx < itemCount; idx ++) {
        [self layoutItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
    }
}

#pragma mark  --私有方法 (为每个Item对象设置相应的frame)
- (void)layoutItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取collectionView的edgeInsets
    UIEdgeInsets edgeInsets = self.sectionInset;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]){
        edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.row];
    }
    self.edgeInsets = edgeInsets;
    
    // 获取collectionView的itemSize
    CGSize itemSize = self.itemSize;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    
    /****************************************核心代码************************************************/
    
    // 遍历相邻三个高度获取最小高度
    NSUInteger col = 0;
    CGFloat shortHeight = [[_colArr firstObject] floatValue];
    for (NSUInteger idx = 0; idx < _colArr.count; idx ++) {
        CGFloat height = [_colArr[idx] floatValue];
        if (height < shortHeight) {
            shortHeight = height;
            col = idx;
        }
    }
    /**
     *  释义:_colArr在出事时,为_colArr=[@"0",@"0",@"0"]; 通过循环取最小值, 
             i=0时 最小值肯定为_colArr[0] ,所以假如此时的item height为50, 那么此时的_colArr就会变成 _colArr=[@"50",@"0",@"0"];
             i=1时 最小值肯定为_colArr[1] ,因为50时大于0,所以假如此时的item height为60,那么此时的_colArr就变成
                 _colArr=[@"50",@"60",@"0"]
             i=2时,最小值肯定为_colorArr[2],因为50或者60都大于0, 所以假如此时的item  height为30,那么此时的_colArr就变成了_colArr=[@"50",@"60",@"30"]
             i=3时,最小值肯定为_colorArr[2],因为50,60都大于0, 所以假如此时的item  height为65,那么此时的_colArr就变成了_colArr =[@"50",@"70",@"95"];
     */
    
    
    // 得到最小高度的当前Y坐标起始高度
    float top = [[_colArr objectAtIndex:col] floatValue];
    // 设置当前cell的frame
    CGRect frame = CGRectMake(edgeInsets.left + col * (edgeInsets.left + itemSize.width), top + edgeInsets.top, itemSize.width, itemSize.height);
    // 把对应的indexPath存放到字典中保存
    [_attributes setObject:indexPath forKey:NSStringFromCGRect(frame)];
    
    // 跟新colArr数组中的高度
    [_colArr replaceObjectAtIndex:col withObject:[NSNumber numberWithFloat:top + edgeInsets.top + itemSize.height]];
   /****************************************核心代码************************************************/
    
}




/**
 *(2)返回collectionView的内容尺寸（没有滚动）
    通过_colArr数组中cell.height 得到collectionView 的contentSize
 */
- (CGSize)collectionViewContentSize {
    CGSize size = self.collectionView.frame.size;
    CGFloat maxHeight = [[_colArr firstObject] floatValue];
    //查找最高的列的高度
    for (NSUInteger idx = 0; idx < _colArr.count; idx++) {
        CGFloat colHeight = [_colArr[idx] floatValue];
        if (colHeight > maxHeight) {
            maxHeight = colHeight;
        }
    }
    size.height = maxHeight + self.edgeInsets.bottom;
    return size;
}

/**
 *(3)系统方法，获取当前可视界面显示的UICollectionViewLayoutAttributes数组(返回rect中的所有的元素的布局属性)
     遍历所有_attributes 获取到rect内所有的cell; 并返回给collectionView
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 把能显示在当前可视界面的所有对象加入在indexPaths 中
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSString * rectStr in _attributes) {
        CGRect cellRect = CGRectFromString(rectStr);
        if (CGRectIntersectsRect(cellRect, rect)) {
            NSIndexPath *indexPath = _attributes[rectStr];
            [indexPaths addObject:indexPath];
        }
    }
    /**
     * CGRectIntersectsRect(rect 1,rect 2)可以判断矩形结构是否交叉，两个矩形对象是否重叠。
     */
    
    // 返回更新对应的UICollectionViewLayoutAttributes数组
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:attribute];
    }
    return attributes;
}

/**
 * (4)更新对应UICollectionViewLayoutAttributes的frame
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    for (NSString *frame in _attributes) {
        if (_attributes[frame] == indexPath) {
            attributes.frame = CGRectFromString(frame);
        }
    }
    return attributes;
}




@end
