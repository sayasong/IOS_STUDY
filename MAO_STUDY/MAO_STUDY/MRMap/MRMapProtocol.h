//
//  MRMapProtocol.h
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRMapProtocol <NSObject>
- (UIView *)getView;
- (instancetype)initWithFrame:(CGRect)frame;
@end
