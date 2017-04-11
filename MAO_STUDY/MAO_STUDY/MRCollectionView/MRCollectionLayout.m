//
//  MRCollectionLayout.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/11.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRCollectionLayout.h"
@interface MRCollectionLayout()
@property (nonatomic, strong) NSMutableDictionary *maxYDict;//这个字典用来存储每一列最大的Y值(每一列的高度)
@property(nonatomic,strong) NSMutableArray *attributeArray;//存放所有的布局属性
@end
@implementation MRCollectionLayout
#pragma 懒加载数据
- (NSMutableDictionary *)maxYDict{
    if (!_maxYDict) {
        _maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}
- (NSMutableArray *)attributeArray{
    if (!_attributeArray) {
        _attributeArray = [[NSMutableArray alloc] init];
    }
    return _attributeArray;
}

#pragma mark -初始化默认值
- (instancetype)init{
    if (self = [super init]) {
        self.columnMargin = 15;
        self.rowMargin = 10;
        self.columnsCount = 3;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

// 返回indexPath这个位置Item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //计算宽度 减去各种间隙即可
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin) / self.columnsCount;
    //代理帮忙算下高度
    CGFloat height = [self.delegate flowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 2.0假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    // 遍历字典找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column_key, NSNumber *maxY_value, BOOL *stop) {
        if ([maxY_value floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column_key;
        }
    }];
    
    // 2.1计算位置
    CGFloat x = self.sectionInset.left + (self.columnMargin + width) * [minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue] + _rowMargin;
    
    self.maxYDict[minColumn] = @(y + height);
    // 3.创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}

// 每次布局之前的准备
- (void)prepareLayout{
    [super prepareLayout];
    // 1.清空最大的Y值
    for (int i = 0; i<self.columnsCount; i++) {
        self.maxYDict[[NSString stringWithFormat:@"%d", i]] = @(self.sectionInset.top);
    }
    [self.attributeArray removeAllObjects];
    
    // 总 item 数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i <count; i++) {
        UICollectionViewLayoutAttributes *attris = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attributeArray addObject:attris];
    }
    
}

// 返回rect范围内的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributeArray;
}

// 返回所有的尺寸
- (CGSize)collectionViewContentSize{
    // 默认最大Y值在第0列
    __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
}
@end
