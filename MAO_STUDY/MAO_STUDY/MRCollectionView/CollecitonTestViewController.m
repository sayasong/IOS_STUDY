//
//  CollecitonTestViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/11.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "CollecitonTestViewController.h"
#import "MRCollectionLayout.h"
static NSString * IDENTIFIER1 = @"IDENTIFIER1";
static NSString * IDENTIFIER2 = @"IDENTIFIER2";
@interface CollecitonTestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MRCollectionLayoutDelegate>{
    CGFloat normal_ItemWidth;
    CGFloat normal_ItemHeight;
    NSInteger ssrItemCount;
}
@property (nonatomic,strong) UICollectionView *normalCollectionView;
@property (nonatomic,strong) UICollectionView *SSRCollectionView;
@property (nonatomic,strong) NSMutableArray *heightArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@end

@implementation CollecitonTestViewController
@synthesize normalCollectionView;
@synthesize SSRCollectionView;
- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray = [[NSMutableArray alloc] init];
    }
    return _heightArray;
}

- (NSMutableArray*)colorArray{
    if (!_colorArray) {
        _colorArray = [[NSMutableArray alloc] init];
    }
    return _colorArray;
}

- (void)loadData{
    ssrItemCount = 40;
    for (int i = 0; i < ssrItemCount; i ++) {
        [self.heightArray addObject:[NSNumber numberWithFloat:100.f*(arc4random()%5)]];
        [self.colorArray addObject:[UIColor colorWithRed:(arc4random()%255)/255.f green:(arc4random()%255)/255.f blue:(arc4random()%255)/255.f alpha:1.f]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initView];
}

- (void)initView{
    self.view.backgroundColor = [UIColor lightGrayColor];
    //普通的
    normal_ItemWidth = SCREEN_WIDTH / 2 - 5.f;
    normal_ItemHeight = 55.f;
    UICollectionViewFlowLayout *vipLayout = [[UICollectionViewFlowLayout alloc] init];
    vipLayout.itemSize = CGSizeMake(normal_ItemWidth,normal_ItemHeight);
    vipLayout.minimumLineSpacing = 0;
    vipLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    normalCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, normal_ItemHeight*2 + 20) collectionViewLayout:vipLayout];
    normalCollectionView.backgroundColor = [UIColor whiteColor];
    normalCollectionView.dataSource = self;
    normalCollectionView.delegate = self;
    normalCollectionView.bounces = false;
    normalCollectionView.tag = 0;
    [normalCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:IDENTIFIER1];
    [self.view addSubview:normalCollectionView];
    //特别的
    MRCollectionLayout *ssrLayout = [[MRCollectionLayout alloc] init];
    ssrLayout.delegate = self;
    SSRCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(normalCollectionView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-(CGRectGetMaxY(normalCollectionView.frame)+10)) collectionViewLayout:ssrLayout];
    SSRCollectionView.backgroundColor = [UIColor whiteColor];
    SSRCollectionView.dataSource = self;
    SSRCollectionView.delegate = self;
    SSRCollectionView.bounces = false;
    SSRCollectionView.tag = 1;
    [SSRCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:IDENTIFIER2];
    [self.view addSubview:SSRCollectionView];
}

+ (void)normalCellAddSubView:(CGSize)size inCell:(UICollectionViewCell *)cell{
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.frame = CGRectMake(5, 5, size.width-10, size.height-10);
    imageview.image = [UIImage imageNamed:@"spaceship"];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageview];
}

#pragma 自定义layout的代理实现
- (CGFloat)flowLayout:(MRCollectionLayout *)flowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    return [self.heightArray[indexPath.row] floatValue];
}

#pragma collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == normalCollectionView) {
        return 4;
    }else if (collectionView == SSRCollectionView) {
        return ssrItemCount;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == normalCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER1 forIndexPath:indexPath];
        [CollecitonTestViewController normalCellAddSubView:CGSizeMake(normal_ItemWidth, normal_ItemHeight) inCell:cell];
        return cell;
    }else if (collectionView == SSRCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER2 forIndexPath:indexPath];
        cell.backgroundColor = self.colorArray[indexPath.row];
        return cell;
    }else{
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

//-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    CGSize size = {SCREEN_WIDTH, 10};
//    return size;
//}
//
//-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    CGSize size = {SCREEN_WIDTH, 10};
//    return size;
//}

@end
