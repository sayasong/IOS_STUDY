//
//  MRCoreImageVC.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/15.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRCoreImageVC.h"
/*test_photo_1*/
@interface MRCoreImageVC ()
@property (nonatomic ,strong) UIImageView *dispalayImageView;
@end

@implementation MRCoreImageVC
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
    //创建出马赛克滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    //滤镜导入图片
    CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"test_photo_1"]];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //打印滤镜的所有参数
    //NSLog(@"滤镜的所有参数:\n[%@]",filter.attributes);
    //设置马赛克滤镜参数为默认值
    [filter setDefaults];
    //导出处理好的图片
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
    //用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
    //导出图片
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return showImage;
}

@end
