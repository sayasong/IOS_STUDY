//
//  navigationManager.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/7.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "navigationManager.h"
@interface navigationManager()
@property (nonatomic ,strong) UINavigationController *nav;
@end
@implementation navigationManager

+ (navigationManager *)shareInstance{
    static navigationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (UINavigationController *)getNav{
    return _nav;
}

- (void)setNav:(UINavigationController *)nav{
    _nav = nav;
}
@end
