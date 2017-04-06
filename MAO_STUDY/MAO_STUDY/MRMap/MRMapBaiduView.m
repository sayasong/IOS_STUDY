//
//  MRMapBaiduView.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRMapBaiduView.h"

@interface MRMapBaiduView ()
@property (nonatomic ,strong) BMKMapView* mapView;
@end

@implementation MRMapBaiduView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _mapView = [[BMKMapView alloc]initWithFrame:frame];
    }
    return self;
}

- (UIView *)getView{
    return _mapView;
}
@end
