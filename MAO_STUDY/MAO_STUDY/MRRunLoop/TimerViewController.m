//
//  TimerViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/10.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "TimerViewController.h"
#import "MRThread.h"
@interface TimerViewController ()
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign,getter=isFinished) BOOL finished;
@property (nonatomic,strong) NSThread *mThread;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViewForTest];
    //[self test];
    [self testInChildThread];
}

- (void)initData{
    _finished = NO;
}

- (void)initViewForTest{
    /*
     如果开启一条线程，那么这个线程上就有一个runloop
     runloop就是一个死循环 为了保证程序不退出
     子线程的runloop默认是不循环的
     */
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/4)];
    _textView.backgroundColor = [UIColor lightGrayColor];
    NSString * str = [NSString stringWithFormat:@"【1】在ios开发的黑年代 使用runloop比较多 【2】runloop负责监听所有的事件：触摸，时钟，网络事件\n"];
    for (int i=0; i<2; i++) {
       str = [str stringByAppendingString:str];
    }
    _textView.text = str;
    [self.view addSubview:_textView];
}

- (void)testInChildThread{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self test];
//    });
    
    MRThread *thread = [[MRThread alloc] initWithBlock:^{
        [self test];
    }];
    [thread start];
    //如果想用强引用描述thread让线程不结束是没用的NSthread本身并不是线程 而是封装用来操作线程的类 线程执行完了照样dealloc 只是指针还指在那里
//    _mThread = [[MRThread alloc] initWithBlock:^{
//        [self test];
//    }];
}

- (void)test{
    //最好就是在子线程里面开启runloop 然后使用 NSDefaultRunLoopMode
    /*
     官方文档中有五种runloop模式 其中两种开发者用不到 1是app第一次启动的时候初始化模式 2是系统内核事件处理模式
     runloop有两种模式 默认和用户交互，两者只能同时处理其中之一 在用户交互模式下，默认模式不处理
     苹果建议 默认模式下放time和网络事件  交互模式下放ui交互事件
    */
    
    /*【1】
     需要手动添加到当前的runloop 
     默认模式：NSDefaultRunLoopMode
     主线程中：拖动textview log就停止打印了
     */
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    /*【2】
     交互模式：UITrackingRunLoopMode
     主线程中：拖动textview才开始打印
     */
    //NSTimer *timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    /*【3】
     占位模式：NSRunLoopCommonModes
     主线程中：一直打印 但是timer事件有耗时操作就会卡ui了
     */
    //NSTimer *timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    /*
     保住子线程runloop 因为子线程本来是没有这玩意的
     */
    //[[NSRunLoop currentRunLoop] run];/*这样run是不会停的 相当于死循环while(YES) 不可取*/
    while (!_finished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0.1]];
    }
    /*
     默认添加进当前的runloop
     */
    //[NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
}

- (void)timerRun:(id)sender{
    [NSThread sleepForTimeInterval:1.f];
    NSLog(@"timerRun[%@]",[NSThread currentThread]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _finished = YES;
    //[_mThread start];
}
@end
