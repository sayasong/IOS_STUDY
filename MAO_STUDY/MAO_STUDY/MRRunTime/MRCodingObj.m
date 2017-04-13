//
//  MRCodingObj.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/13.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRCodingObj.h"
#import <objc/runtime.h>

@implementation MRCodingObj

//全属性归档
- (void)encodeWithCoder:(NSCoder *)coder
{
    [MRCodingObj coreHandler:^(NSString *key){
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }];
}

//全属性解档
- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        [MRCodingObj coreHandler:^(NSString *key){
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }];
    }
    return self;
}

+ (void)coreHandler:(void(^)(NSString *))handle{
    unsigned int count = 0;
    //获取类的所有属性
    Ivar *ivars = class_copyIvarList([MRCodingObj class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        handle(key);
    }
}

@end
