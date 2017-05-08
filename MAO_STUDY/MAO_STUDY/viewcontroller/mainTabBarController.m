//
//  mainTabBarController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/5/8.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "mainTabBarController.h"
#import "mainTabBar.h"
@interface mainTabBarController ()

@end

@implementation mainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setValue:[[mainTabBar alloc] init] forKey:@"tabBar"];
        UIViewController *vc1 = [[UIViewController alloc] init];
        vc1.title = @"第一页";
        UIViewController *vc2 = [[UIViewController alloc] init];
        vc2.title = @"第二页";
        self.viewControllers = [NSArray arrayWithObjects:vc1,vc2,nil];
    }
    return self;
}

@end
