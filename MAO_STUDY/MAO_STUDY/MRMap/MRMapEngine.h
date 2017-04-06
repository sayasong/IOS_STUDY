//
//  MRMapEngine.h
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRMapFactoryProtocol.h"
@interface MRMapEngine : NSObject
- (id<MRMapFactoryProtocol>)getFactory;
@end
