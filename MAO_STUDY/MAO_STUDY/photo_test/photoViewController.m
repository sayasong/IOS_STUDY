//
//  photoViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/5/11.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "photoViewController.h"

@interface photoViewController ()

@end

@implementation photoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self allNotEmptySystemAlbums];
    });
}

- (void)allNotEmptySystemAlbums
{
    PHFetchResult<PHAssetCollection *> *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (int i = 0; i < fetchResult.count; i++) {
        PHAssetCollection *album = [fetchResult objectAtIndex:i];
        if (album && [album isKindOfClass:[PHAssetCollection class]]) {
            [self enumerateAssetsInAssetCollection:album original:YES];
        }
    }
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"图片:%@[%@]", result,info);
        }];
    }
}

@end
