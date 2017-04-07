//
//  MRAvViewController.h
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/7.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "baseViewController.h"
typedef NS_OPTIONS(NSInteger, AV_TYPE) {
    AV_TYPE_SPEAK,
    AV_TYPE_VIDEO,
    AV_TYPE_RECORD
};
@interface MRAvViewController : baseViewController
@property (nonatomic,assign) AV_TYPE avType;
@end
