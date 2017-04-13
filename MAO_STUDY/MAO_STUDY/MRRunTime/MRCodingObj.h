//
//  MRCodingObj.h
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/13.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCodingObj : NSObject<NSCoding>
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSUInteger workage;
@end
