//
//  MRRuntimeObj.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/14.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRRuntimeObj.h"
#import <objc/message.h>
@implementation MRRuntimeObj
- (void)LOL{
    NSLog(@"HAHA");
}

- (void)LOL:(NSString *)str{
    NSLog(@"HAHA_%@",str);
}

//发现该类有实例方法没有被实现
//补充一下 SEL是方法编号哦
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"%@方法未实现",NSStringFromSelector(sel));
    if (sel == @selector(LOL_ERROR)) {//动态添加方法以解决
        class_addMethod([self class], sel, (IMP)change, "");
    }
    //还可以转发给别的方法去实现
    return [super resolveInstanceMethod:sel];
}

/*
 所有方法都有这两个隐式参数(id self ,SEL _cmd)方法所属对象和方法的编号
 比较一下就看懂了
 Method URLWithStr = class_getClassMethod([NSURL class], @selector(URLWithString:));
 */
void change(id mm,SEL _cmd){
    NSLog(@"未实现方法被解决%@",mm);
}

@end
