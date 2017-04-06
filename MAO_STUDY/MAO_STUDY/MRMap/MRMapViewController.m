//
//  MRMapViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRMapViewController.h"

@interface MRMapViewController ()

@end

@implementation MRMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:mapView];
}

@end
