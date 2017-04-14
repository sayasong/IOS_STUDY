//
//  RuntimeCodingViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/13.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "RuntimeCodingViewController.h"
#import "MRCodingObj.h"
//#import "MRRuntimeObj.h"
#import <objc/message.h>

//用来被观察的类
@interface MRChild : NSObject
@property (nonatomic ,strong) NSString *age;
@end
@implementation MRChild
@end
//观察类
@interface MRObserver : NSObject

@end

@implementation MRObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"监听到了,keyPath:%@,object:%@,change:%@,context:%@",keyPath,object,change,context);
}
@end

@interface RuntimeCodingViewController ()
@property (nonatomic,strong) MRChild *child;
@property (nonatomic,strong) MRObserver *observer;
@end

@implementation RuntimeCodingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testForOb];
    [self testForMessageSend];
    [self testForFunctionExchange];
}

- (void)testForOb{
    self.child = [MRChild new];
    self.observer = [MRObserver new];
    [self.child addObserver:self.observer forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.child.age = @"1";
    //isa	Class	NSKVONotifying_MRChild	0x0000600000300090
    //isa	Class	MRObserver	0x000000010cfe48e0
    //被观察者已经被重建了 不再是原来的那个类了 继承的新类重写了set方法 并在里面发送通知
}

//消息发送机制初探 代码完全C语言化
- (void)testForMessageSend{
    //objc/message 包含 objc/runtime
    
    //build settings 中 enable strict checking of obj_msgSend Calls 要设置为 NO 因为在Xcode5.0之后 苹果不建议使用底层代码 建议使用runtime
    
    //MRRuntimeObj *obj = [[MRRuntimeObj alloc] init];;
    //[obj performSelector:@selector(LOL)];
    
    //NSClassFromString(@"MRRuntimeObj");
    
    //MRRuntimeObj *obj = objc_msgSend([MRRuntimeObj class], @selector(alloc));
    id obj = objc_msgSend(objc_getClass("MRRuntimeObj"), sel_registerName("alloc"));
    obj = objc_msgSend(obj, sel_registerName("init"));
    objc_msgSend(obj,sel_registerName("LOL"));
    objc_msgSend(obj,sel_registerName("LOL:"),@"hehe");
    objc_msgSend(obj,sel_registerName("LOL_ERROR"));
    //根文件夹下还有一个project名为testForClang 用来查看编译后的C代码是否与我们所想的一致
    //编译指令:clang -rewrite-objc main.m 编译得到一个cpp 最下面就是我们要看的
    /*
     int main(int argc, const char * argv[]) {
     Person *person = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
     return 0;
     }
     */
}

//runtime动态交换方法
- (void)testForFunctionExchange{
    //url中掺入中文使得到的nsurl为空
    NSURL *url = [NSURL URLWithString:@"www.baidu.com/中文"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"生成的网络请求%@",request);
}

//批量获取方法的所有属性
- (IBAction)codingBtnClicked:(UIButton *)sender {
    //创建需要归档的类
    MRCodingObj *obj = [[MRCodingObj alloc] init];
    obj.name = @"maorui";
    obj.age = 25;
    obj.workage = 2;
    obj.location = @"上海";
    //获取沙河路径
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath1 = [temp stringByAppendingPathComponent:@"coding1.mr"];
    NSString *filePath2 = [temp stringByAppendingPathComponent:@"coding2.mr"];
    //归档
    [NSKeyedArchiver archiveRootObject:obj toFile:filePath1];
    [NSKeyedArchiver archiveRootObject:obj toFile:filePath2];
}

- (IBAction)encodingBtnClicked:(UIButton *)sender {
    //路径
    NSString * temp = NSTemporaryDirectory();
    NSString * filePath = [temp stringByAppendingPathComponent:@"coding1.mr"];
    //解档
    MRCodingObj *obj =  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    NSLog(@"[%@][%zd]岁,在[%@]工作[%zd]年了",obj.name,obj.age,obj.location,obj.workage);
}

@end
