//
//  MROpenGlesViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/24.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MROpenGlesViewController.h"
#import <GLKit/GLKit.h>//GPU渲染专用类库
@interface MROpenGlesViewController ()
@property (nonatomic, strong) GLKView *glkView;//渲染用的buffer视图
@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) CIImage *ciImage;
@property (nonatomic, strong) CIContext *ciContext;
@property (nonatomic, strong) UISlider *slider;
@end

@implementation MROpenGlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    UIImage *showImage = [UIImage imageNamed:@"test_photo_1"];
    CGRect rect = CGRectMake(0, 0, showImage.size.width, showImage.size.height);
    
    //获取opengles渲染的上下文
    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //创建出渲染用的buffer
    _glkView = [[GLKView alloc] initWithFrame:rect context:eaglContext];
    [_glkView bindDrawable];
    [self.view addSubview:_glkView];
    
    //创建出渲染coreimage用的上下文
    _ciContext = [CIContext contextWithEAGLContext:eaglContext options:@{kCIContextOutputColorSpace : [NSNull null]}];
    
    //设置滤镜
    _ciImage = [[CIImage alloc] initWithImage:showImage];
    _filter = [CIFilter filterWithName:@"CISepiaTone"];//老电影滤镜
    [self displayImage:0.f];
    
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 20)];
    _slider.minimumValue = 0.f;
    _slider.maximumValue = 1.f;
    [_slider addTarget:self action:@selector(sliderEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}

- (void)sliderEvent:(UISlider *)slider{
    [self displayImage:slider.value];
}

- (void)displayImage:(CGFloat)value{
    //动态设置滤镜
    [_filter setValue:_ciImage forKey:kCIInputImageKey];
    [_filter setValue:@(value) forKey:kCIInputIntensityKey];
    
    //开始渲染
    [_ciContext drawImage:[_filter valueForKey:kCIOutputImageKey]
                   inRect:CGRectMake(0, 0, _glkView.drawableWidth, _glkView.drawableHeight)
                 fromRect:[_ciImage extent]];
    [_glkView display];
}

@end
