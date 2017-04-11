//
//  RunLoopViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/10.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "RunLoopViewController.h"
//任务 block
typedef void(^RunloopBlock) (void);

static NSString * IDENTIFIER = @"IDENTIFIER";
static CGFloat CELL_HEIGHT = 135.f;
@interface RunLoopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UITableView *exampleTableView;
@property (nonatomic,strong) NSMutableArray *tasks;//这里面放任务
@property (nonatomic,assign) NSUInteger maxQueueLength;//最大队列长度
@end

@implementation RunLoopViewController
-(void)timerMethod{
    //任何事情都不做!!!
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [_exampleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER];
    //添加Runloop的观察者
    [self addRunloopObserver];
    //初始化
    _tasks = [NSMutableArray array];
    _maxQueueLength = 18;
}

//MARK: 内部实现方法
//添加文字
+(void)addlabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 4;
    [cell.contentView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    label1.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    label1.font = [UIFont boldSystemFontOfSize:13];
    label1.tag = 5;
    [cell.contentView addSubview:label1];
    
}
//加载第一张
+(void)addImage1With:(UITableViewCell *)cell{
    //第一张
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView.tag = 1;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}
//加载第二张
+(void)addImage2With:(UITableViewCell *)cell{
    //第二张
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView1.tag = 2;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.image = image1;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView1];
    } completion:nil];
}
//加载第三张
+(void)addImage3With:(UITableViewCell *)cell{
    //第三张
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView2.tag = 3;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.image = image2;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView2];
    } completion:nil];
}

//加载tableview
- (void)initView {
    self.exampleTableView = [UITableView new];
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
    self.exampleTableView.frame = self.view.frame;
    [self.view addSubview:self.exampleTableView];
}

#pragma mark - <tableview>
//Cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 399;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //干掉contentView上面的子控件!! 节约内存!!
    for (NSInteger i = 1; i <= 5; i++) {
        //干掉contentView 上面的所有子控件!!
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
    //添加文字
    [RunLoopViewController addlabel:cell indexPath:indexPath];
    //添加图片  -- 耗时操作!!!  丢给每一次RunLoop循环!!!
    [self addTask:^{
        [RunLoopViewController addImage1With:cell];
    }];
    [self addTask:^{
        [RunLoopViewController addImage2With:cell];
    }];
    [self addTask:^{
        [RunLoopViewController addImage3With:cell];
    }];
    return cell;
}

#pragma CF代码监听runloop 在回调里处理放进数组的block方法来加载图片
//添加任务
- (void)addTask:(RunloopBlock)task{
    [_tasks addObject:task];
    //保证不在界面上的图片不加载
    if (self.tasks.count > _maxQueueLength) {
        [self.tasks removeObjectAtIndex:0];
    }
}

static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NSLog(@"回调");
    //取出任务数组
    RunLoopViewController *vc = (__bridge RunLoopViewController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    //执行数组中的block
    RunloopBlock task = vc.tasks.firstObject;
    task();
    [vc.tasks removeObjectAtIndex:0];
}

//添加runloop的观察者
- (void)addRunloopObserver{
    //拿到当前的runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    //定义观察者
    static CFRunLoopObserverRef defaultModeObserver;
    //创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &Callback, &context);
    //选择观察对象
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopCommonModes);
    //释放
    CFRelease(defaultModeObserver);
}

@end
