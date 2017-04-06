//
//  MWPhotoBrowserTestViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/11.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MWPhotoBrowserTestViewController.h"

@interface MWPhotoBrowserTestViewController ()<MWPhotoBrowserDelegate>{
    //图片 视频 预览数组
    NSMutableArray *photos;
    NSMutableArray *thumbs;
}
@property (strong, nonatomic) MWPhotoBrowser *browser;
@property (strong, nonatomic) UIButton *displayBtn;
@end

@implementation MWPhotoBrowserTestViewController
@synthesize browser;
@synthesize displayBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initView{
    displayBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:displayBtn];
    displayBtn.backgroundColor = [UIColor blackColor];
    [displayBtn addTarget:self action:@selector(imagePreview) forControlEvents:UIControlEventTouchUpInside];
    [displayBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left);
    }];
}

- (void)reloadData{
    [self reloadImageData];
}

//MWPHOTO(视频及图片预览)===========================================
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < thumbs.count)
        return [thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    __weak typeof (self)weakSelf = self;
    [photoBrowser dismissViewControllerAnimated:YES completion:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.browser = nil;
    }];
}


//    MWPhoto *photo1 = [MWPhoto photoWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_photo_1" ofType:@"png"]]];
//    MWPhoto *thumb1 = [MWPhoto photoWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lock_btn_unselected" ofType:@"png"]]];
- (void)reloadImageData
{
    if (!photos){
        photos = [NSMutableArray new];
        thumbs = [NSMutableArray new];
    }
    MWPhoto *photo1 = [MWPhoto photoWithImage:[UIImage imageNamed:@"test_photo_1"]];
    photo1.caption = @"pic1";
    [photos addObject:photo1];
    MWPhoto *thumb1 = [MWPhoto photoWithImage:[UIImage imageNamed:@"lock_btn_unselected"]];
    [thumbs addObject:thumb1];
    
    MWPhoto *photo2 = [MWPhoto photoWithImage:[UIImage imageNamed:@"test_photo_2"]];
    photo2.caption = @"pic2";
    [photos addObject:photo2];
    MWPhoto *thumb2 = [MWPhoto photoWithImage:[UIImage imageNamed:@"lock_btn_selected"]];
    [thumbs addObject:thumb2];
}

- (void)imagePreview
{
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[[navigationManager shareInstance] getNav] presentViewController:nc animated:YES completion:nil];
}



@end
