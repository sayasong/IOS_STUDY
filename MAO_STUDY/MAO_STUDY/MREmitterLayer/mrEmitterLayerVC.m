//
//  mrEmitterLayerVC.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/7.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

//继续提高 cagradientlayer
#import "mrEmitterLayerVC.h"
#import "snowView.h"
@interface mrEmitterLayerVC ()

@end

@implementation mrEmitterLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    /*简单的例子
    
    //创建出layer
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    //显示边框
    emitterLayer.borderWidth = 1.f;
    //防止粒子超出layer
    //emitterLayer.masksToBounds = YES;
    //给定尺寸
    emitterLayer.frame = CGRectMake(100, 100, 100, 100);
    //发射点
    emitterLayer.emitterPosition = CGPointMake(0, 0);
    //发射模式
    emitterLayer.emitterMode = kCAEmitterLayerSurface;
    //发射形状
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    [self.view.layer addSublayer:emitterLayer];
    
    //创建粒子
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    //产生率
    cell.birthRate = 10;
    //生命周期
    cell.lifetime = 100.f;
    //速度
    cell.velocity = 10.f;
    //速度偏差
    cell.velocityRange = 3.f;
    //Y轴加速度
    cell.yAcceleration = 2.f;
    //发射角度
    cell.emissionRange = 4.f *M_1_PI;
    //颜色
    cell.color = [UIColor redColor].CGColor;
    //图片
    cell.contents = (__bridge id)([UIImage imageNamed:@"happyness"].CGImage);
    
    emitterLayer.emitterCells = [NSArray arrayWithObjects:cell, nil];
    
    */
    UIImageView *alphaView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    alphaView1.image = [UIImage imageNamed:@"alpha"];
    UIImageView *alphaView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    alphaView2.image = [UIImage imageNamed:@"alpha"];
    
    mrBaseEmitterLayerView *mSnowView = [[snowView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    mSnowView.maskView = alphaView1; 渐变
    [self.view addSubview:mSnowView];
    [mSnowView show];
}

@end
