//
//  MRComplexCoreImageViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/24.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRComplexCoreImageViewController.h"

@interface MRComplexCoreImageViewController ()
@property (nonatomic ,strong) UIImageView *dispalayImageView;
@end

@implementation MRComplexCoreImageViewController
@synthesize dispalayImageView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    dispalayImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:dispalayImageView];
    [dispalayImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
    [dispalayImageView setImage:[self funcOfImage]];
}

- (UIImage *)funcOfImage{
    

    CIFilter *filterOne = [CIFilter filterWithName:@"CIPixellate"];
    CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"test_photo_1"]];
    [filterOne setValue:ciImage forKey:kCIInputImageKey];
    [filterOne setDefaults];
    CIImage *outImage = [filterOne valueForKey:kCIOutputImageKey];
    
    //上一个滤镜输出的ciimage为下一个滤镜的输入
    CIFilter *filterTwo = [CIFilter filterWithName:@"CIHueAdjust"];
    [filterTwo setValue:outImage forKey:kCIInputImageKey];
    [filterTwo setDefaults];
    [filterTwo setValue:@(1.f) forKey:kCIInputAngleKey];//色调滤镜需要设定这个值
    CIImage *outputImage = [filterTwo valueForKey:kCIOutputImageKey];
    
    //用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    //导出图片
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return showImage;
}

@end
