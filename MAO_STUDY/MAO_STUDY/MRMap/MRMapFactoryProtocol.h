//
//  MRMapFactoryProtocol.h
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRMapProtocol.h"
@protocol MRMapFactoryProtocol <NSObject>
//基本地图显示
- (id<MRMapProtocol>)getMapView:(CGRect)frame;
@end
