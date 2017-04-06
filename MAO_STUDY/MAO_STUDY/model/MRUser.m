//
//  MRUser.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/7.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRUser.h"
@implementation MRUser

/*admin nomaluser*/
@synthesize userName;
/*锁屏图案*/
@synthesize lockPassword;

- (NSString *)description{
    return [NSString stringWithFormat:@"username = %@,lockPassword = %@",self.userName,self.lockPassword];
}

@end
