//
//  mainViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/4.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "mainViewController.h"
#import "gcdStudyManager.h"
#import "lockWindow.h"

#import "mrEmitterLayerVC.h"
#import "MWPhotoBrowserTestViewController.h"
#import "socketTestViewController.h"
#import "MRCoreImageVC.h"
#import "MRComplexCoreImageViewController.h"
#import "MROpenGlesViewController.h"
#import "MRMapViewController.h"
#import "MRAvViewController.h"
#import "TimerViewController.h"
#import "GCDTimerViewController.h"
#import "RunLoopViewController.h"
#import "CollecitonTestViewController.h"
#import "RuntimeCodingViewController.h"
#import "MRQRCodeViewController.h"
#import "mainTabBarController.h"
typedef void (^TEST_BLOCK_1)(int,NSString *);
typedef void (^TEST_BLOCK_2)(int i,NSString *str);
@interface mainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,weak) void (^TEST_BLOCK_3)(int,NSString *);
@property (nonatomic ,weak) void (^TEST_BLOCK_4)(int i,NSString *str);
@property (nonatomic ,strong) lockWindow *mainlockWindow;
@property (nonatomic ,strong) NSMutableDictionary *tableViewData;
@property (nonatomic ,strong) UITableView *testVcTableview;
@end

@implementation mainViewController
@synthesize mainlockWindow;

- (void)blockTest{
    [self testFuncF:^(int i,NSString *str){
        NSLog(@"%d,[%@]",i,str);
    }];
    [self testFuncS:^(int i,NSString *str){
        NSLog(@"%d,[%@]",i,str);
    }];
    [self testFuncH:^(int i,NSString *str){
        NSLog(@"%D,[%@]",i,str);
    }];
}

- (void)testFuncF:(void(^)(int,NSString *))block{
    block(1,@"111");
    NSLog(@"testFuncF");
}

- (void)testFuncS:(void(^)(int i,NSString *str))block{
    block(2,@"222");
    NSLog(@"testFuncS");
}

- (void)testFuncH:(void(^)(int,NSString *str))block{
    block(3,@"333");
    NSLog(@"testFuncH");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initView];
}

- (void)initView{
//    mainlockWindow = [[lockWindow alloc] init];
//    [mainlockWindow show];
    
    self.testVcTableview = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.testVcTableview];
    [self.testVcTableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.testVcTableview setBackgroundColor:[UIColor whiteColor]];
    self.testVcTableview.delegate = self;
    self.testVcTableview.dataSource = self;
    
}

//递归 整数各位相加 加完后的结果继续各位相加
- (NSInteger)numadd:(NSInteger)num{
    if (num/10 == 0) {
        return num;
    }else{
        int sum = 0;
        while(0 != num){
            sum += num%10;
            num/= 10;
        }
        return [self numadd:sum];
    }
}

- (void)loadData{
    //[self test];
    //[1] 粒子效果CAEmitterLayer
    NSInteger x = [self numadd:777];
    NSLog(@"X = %ld",(long)x);
    [self blockTest];
    [self dbTest];
    [self addDataWithTotalKey:@"粒子效果CAEmitterLayer"
                       WithVC:[mrEmitterLayerVC new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"MWPhotoBrowser"
                       WithVC:[MWPhotoBrowserTestViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"Socket编程"
                       WithVC:[socketTestViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"CoreImage"
                       WithVC:[MRCoreImageVC new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"CoreImage2"
                       WithVC:[MRComplexCoreImageViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"CoreImage3"
                       WithVC:[MROpenGlesViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"地图"
                       WithVC:[MRMapViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"AV框架_点读机"
                       WithVC:[MRAvViewController new]
                 WithVCParams:@{@"avType":[NSNumber numberWithInteger:AV_TYPE_SPEAK]}];
    [self addDataWithTotalKey:@"AV框架_视频播放器"
                       WithVC:[MRAvViewController new]
                 WithVCParams:@{@"avType":[NSNumber numberWithInteger:AV_TYPE_VIDEO]}];
    [self addDataWithTotalKey:@"AV框架_录音"
                       WithVC:[MRAvViewController new]
                 WithVCParams:@{@"avType":[NSNumber numberWithInteger:AV_TYPE_RECORD]}];
    [self addDataWithTotalKey:@"Runloop_timer"
                       WithVC:[TimerViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"Runloop_GCD_timer"
                       WithVC:[GCDTimerViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"Runloop_Example"
                       WithVC:[RunLoopViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"Collectionview以及自定义写法的错位瀑布流"
                       WithVC:[CollecitonTestViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"Runtime_归档解档_方法交换"
                       WithVC:[RuntimeCodingViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"二维码"
                       WithVC:[MRQRCodeViewController new]
                 WithVCParams:nil];
    [self addDataWithTotalKey:@"自定义tabbar"
                       WithVC:[mainTabBarController new]
                 WithVCParams:nil];
}

- (void)test{
    gcdStudyManager *manager = [[gcdStudyManager alloc] init];
    [manager test1];
    [manager test2];
    [manager test3];
    [manager test4];
}

- (void)dbTest{
    MRUser *user1 = [[MRUser alloc]init];
    user1.lockPassword = @"123";
    user1.userName = @"沙屿";
    
    MRUser *user2 = [[MRUser alloc]init];
    user2.lockPassword = @"012";
    user2.userName = @"陈亮";
    
    [[MRDBHelper shareInstance] insertIntoTable:USER_TABLE_NAME withObjects:[NSArray arrayWithObjects:user1,user2,nil]];
    
    //[[MRDBHelper shareInstance] deleteFromTable:USER_TABLE_NAME withConditionsfield:[NSArray arrayWithObject:[NSString stringWithFormat:@"%@ = ?",USER_USERNAME]] andConditions:[NSArray arrayWithObject:@"陈亮"]];
    [[MRDBHelper shareInstance] updateInTableWithSql:[NSString stringWithFormat:@"update %@ set %@ = ? where %@ = ?",USER_TABLE_NAME,USER_USERNAME,USER_USERNAME] andValues:[NSArray arrayWithObjects:@"CCLLL",@"CL", nil]];
    
    NSArray *array = [[MRDBHelper shareInstance] getModelsFormTableWithSql:[NSString stringWithFormat:@"select * from %@ where %@ = ?",USER_TABLE_NAME,USER_USERNAME] andValues:[NSArray arrayWithObjects:@"CCLLL",nil] andTableName:USER_TABLE_NAME];
    NSLog(@"查询到的数据%@",array);
}

- (NSMutableDictionary *)tableViewData{
    if (!_tableViewData) {
        _tableViewData = [[NSMutableDictionary alloc] init];
    }
    return _tableViewData;
}

#pragma 数据处理私有方法
- (id)getInfoFromTableviewDataForKey:(NSString *)key inIndex:(NSInteger)index{
    if (self.tableViewData.count >= index + 1) {
        NSDictionary *dic = [self.tableViewData objectForKey:[self.tableViewData allKeys][index]];
        return [dic objectForKey:key];
    }else{
        NSLog(@"并没有那么多行");
    }
    return nil;
}

/*
 key:用作cell的显示文本信息
 {
 @"VC" 已经初始化好的vc
 @"params" 装有vc属性的字典
 }
 */
- (void)addDataWithTotalKey:(NSString *)totalKey
                     WithVC:(id)vc
               WithVCParams:(NSDictionary *)params{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (vc) {
        if (params && params.count>0) {
            [vc setValuesForKeysWithDictionary:params];
        }
        [dic setObject:vc forKey:@"VC"];
    }
    [self.tableViewData setObject:dic forKey:totalKey];
}

#pragma tabview数据源及代理
/*
 * [M]处代码换成如下可以解决重用的问题，但是不推荐
 * UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
 * 还是自定义cell 然后先清空所有的subview再添加subview 这样解决比较靠谱
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier_test";
    //从重用池内取出cell 这里没有传入indexpath所以拿出的cell不知道是哪一行的[M]
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //重用池内取不出cell就new一个新的
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.tableViewData allKeys][MR_ROW];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"总行数%lu",(unsigned long)self.tableViewData.count);
    return self.tableViewData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [self getInfoFromTableviewDataForKey:@"VC" inIndex:MR_ROW];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    return;
}

@end
