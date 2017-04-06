//
//  MRMapGaodeView.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRMapGaodeView.h"

@interface MRMapGaodeView ()
@property (nonatomic ,strong) MAMapView* mapView;
@end

@implementation MRMapGaodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _mapView = [[MAMapView alloc]initWithFrame:frame];
    }
    return self;
}

- (UIView *)getView{
    return _mapView;
}
@end
