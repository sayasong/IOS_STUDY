//
//  NSURL+MR.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/13.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "NSURL+MR.h"
#import <objc/message.h>

@implementation NSURL (MR)

+ (void)load{
    Method URLWithStr = class_getClassMethod([NSURL class], @selector(URLWithString:));
    Method MRURLWithStr = class_getClassMethod([NSURL class], @selector(MR_URLWithString:));
    //系统方法换成自己重写的 自己重写的换成系统的
    method_exchangeImplementations(URLWithStr, MRURLWithStr);
}

+ (instancetype)MR_URLWithString:(NSString *)URLStirng{
    NSURL * url = [NSURL MR_URLWithString:URLStirng];//因为方法调换过了 这里其实在调系统方法 防止调用自己
    if (url == nil) {
        NSLog(@"检测到URL初始化失败,初始化为空!");
    }
    return url;
}

@end
