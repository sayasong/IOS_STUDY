//
//  MRMapFactoryBaidu.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRMapFactoryBaidu.h"
#import "MRMapBaiduView.h"
@implementation MRMapFactoryBaidu

- (id<MRMapProtocol>)getMapView:(CGRect)frame{
    return [[MRMapBaiduView alloc] initWithFrame:frame];
}

@end
