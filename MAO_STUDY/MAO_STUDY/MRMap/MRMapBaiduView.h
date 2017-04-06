//
//  MRMapBaiduView.h
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRMapProtocol.h"
//遵循协议之后 协议里面定义的方法 当前类.h未声明都能被外部调用
@interface MRMapBaiduView : NSObject<MRMapProtocol> //这里继承nsobject 否则协议里面initwithframe方法就变成重写父类方法了

@end
