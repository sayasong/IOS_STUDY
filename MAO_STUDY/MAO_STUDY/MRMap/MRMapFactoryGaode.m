//
//  MRMapFactoryGaode.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRMapFactoryGaode.h"
#import "MRMapGaodeView.h"
@implementation MRMapFactoryGaode

- (id<MRMapProtocol>)getMapView:(CGRect)frame{
    return [[MRMapGaodeView alloc] initWithFrame:frame];
}

@end