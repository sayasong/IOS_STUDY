//
//  MRCollectionLayout.h
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/11.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRCollectionLayout;
@protocol MRCollectionLayoutDelegate <NSObject>
//固定宽度 让代理拿图片宽高按比例算高度
- (CGFloat)flowLayout:(MRCollectionLayout *)flowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end

@interface MRCollectionLayout : UICollectionViewLayout

@property (nonatomic,assign) CGFloat columnMargin;//列间距
@property (nonatomic,assign) CGFloat rowMargin;//行间距
@property (nonatomic,assign) int columnsCount;//列数
@property (nonatomic,assign) UIEdgeInsets sectionInset;//外边距

@property (nonatomic, weak) id<MRCollectionLayoutDelegate> delegate;

@end
