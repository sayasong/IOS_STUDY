//
//  navigationManager.h
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/7.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "baseManager.h"

@interface navigationManager : baseManager
+ (id)shareInstance;
- (UINavigationController *)getNav;
- (void)setNav:(UINavigationController *)nav;
@end
