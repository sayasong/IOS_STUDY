//
//  MRMapEngine.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRMapEngine.h"
#import "MRMapFactoryBaidu.h"
#import "MRMapFactoryGaode.h"

@implementation MRMapEngine
- (id<MRMapFactoryProtocol>)getFactory{
    return [[MRMapFactoryBaidu alloc] init];
}
@end
