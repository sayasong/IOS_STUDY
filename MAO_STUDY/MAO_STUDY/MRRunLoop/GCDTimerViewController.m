//
//  GCDTimerViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/10.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "GCDTimerViewController.h"

@interface GCDTimerViewController ()
@property (nonatomic,strong) dispatch_source_t timer;
@end

@implementation GCDTimerViewController

//runloop只处理三种东西 【1】source事件源 0系统发送的/1 【2】observer观察者 【3】timer

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test{
    //第一个参数是线程优先级 第二个参数无意义
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //创建timer
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置timer
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"MMMMMMMMMMMM[%@]",[NSThread currentThread]);
    });
    dispatch_time_t start = DISPATCH_TIME_NOW;
    dispatch_time_t interval = 1.0 * NSEC_PER_SEC;//单位是纳秒
    dispatch_source_set_timer(_timer, start, interval, 0);
    //启动
    dispatch_resume(_timer);
}

@end
