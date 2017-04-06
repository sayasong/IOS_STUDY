//
//  gcdStudyManager.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/4.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "gcdStudyManager.h"
@interface gcdStudyManager()
@property (nonatomic ,strong) NSMutableDictionary *keysDic;
@end
@implementation gcdStudyManager
/*
 dispatch_queue_create(oneQueueName, DISPATCH_QUEUE_CONCURRENT);
 dispatch_queue_create(oneQueueName, DISPATCH_QUEUE_SERIAL);
 */
- (void)test1{
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; i++)
    {
        NSLog(@"[%d] 尝试创建线程",i);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"线程[%d]",i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"finish");
}

#pragma 信号量实现:异步请求 同步return
- (void)test2{
    NSLog(@"token = %@",[self test2Function]);
}

- (NSString *)test2Function{
    __block NSString*token = nil;
    dispatch_semaphore_t dispatchSemaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        token = @"test2Token";
        dispatch_semaphore_signal(dispatchSemaphore);
    });
    dispatch_semaphore_wait(dispatchSemaphore, DISPATCH_TIME_FOREVER);
    return token;
}

#pragma GCDGroup实现:批量的异步线程 等待(异步线程按先后顺序执行)
- (void)test3{
    __block NSMutableArray *token = [[NSMutableArray alloc] init];
    NSDictionary *tokenInfoDic = @{@"1":@"token1",@"2":@"token2",@"3":@"token3"};
    [self groupCreat:@"key" count:tokenInfoDic.count];
    [self groupNotify:@"key" block:^{
        NSLog(@"test3 token = [%@]",token);
    }];
    for (int index = 0; index < tokenInfoDic.count; index ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *key = [NSString stringWithFormat:@"%d",index+1];
            [token addObject:[tokenInfoDic objectForKey:key]];
            [self groupLeave:@"key"];
        });
    }
}

- (NSMutableDictionary *)keysDic{
    if (!_keysDic) {
        _keysDic = [[NSMutableDictionary alloc] init];
    }
    return _keysDic;
}

- (void)groupCreat:(NSString *)key count:(NSUInteger)count{
    dispatch_group_t group = dispatch_group_create();
    for (NSUInteger i = 0; i<count; i++) {
        dispatch_group_enter(group);
    }
    [self.keysDic setObject:group forKey:key];
}

- (void)groupLeave:(NSString*)key{
    dispatch_group_leave([self.keysDic objectForKey:key]);
}

- (void)groupNotify:(NSString*)key block:(void(^)())block{
    dispatch_group_notify([self.keysDic objectForKey:key], dispatch_get_global_queue(0, 0), ^{
        block();
        [self.keysDic removeObjectForKey:key];
    });
}

#pragma GCDGroup 线程组等待执行两种写法

- (void)test4{
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_group_enter(group1);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"test4 线程1");
        dispatch_group_leave(group1);
    });
    dispatch_group_enter(group1);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"test4 线程2");
        [NSThread sleepForTimeInterval:2];
        dispatch_group_leave(group1);
    });
    dispatch_group_notify(group1, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"test4 线程3");
    });
    
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_group_async(group2,dispatch_get_global_queue(0, 0),^{
        NSLog(@"test4 线程11");
    });
    dispatch_group_async(group2,dispatch_get_global_queue(0, 0),^{
        NSLog(@"test4 线程22");
    });
    dispatch_group_notify(group2, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"test4 线程33");
    });
}

@end
