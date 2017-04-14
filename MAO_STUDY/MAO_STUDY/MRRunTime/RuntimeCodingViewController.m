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
@interface RuntimeCodingViewController ()

@end

@implementation RuntimeCodingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testForMessageSend];
    [self testForFunctionExchange];
}

- (void)testForMessageSend{
    //build settings 中 enable strict checking of obj_msgSend Calls 要设置为 NO 因为在Xcode5.0之后 苹果不建议使用底层代码 建议使用runtime
    
    //MRRuntimeObj *obj = [[MRRuntimeObj alloc] init];;
    //[obj performSelector:@selector(LOL)];
    
    //NSClassFromString(@"MRRuntimeObj");
    
    //MRRuntimeObj *obj = objc_msgSend([MRRuntimeObj class], @selector(alloc));
    id obj = objc_msgSend(objc_getClass("MRRuntimeObj"), sel_registerName("alloc"));
    obj = objc_msgSend(obj, sel_registerName("init"));
    objc_msgSend(obj,sel_registerName("LOL"));
    objc_msgSend(obj,sel_registerName("LOL:"),@"hehe");
    
}

- (void)testForFunctionExchange{
    //url中掺入中文使得到的nsurl为空
    NSURL *url = [NSURL URLWithString:@"www.baidu.com/中文"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"生成的网络请求%@",request);
}

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
