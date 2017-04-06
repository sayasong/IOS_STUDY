//
//  socketTestViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/12.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "socketTestViewController.h"

@interface socketTestViewController ()<NSStreamDelegate,UITextFieldDelegate>{
    NSInputStream *_inputStream;//对应输入流
    NSOutputStream *_outputStream;//对应输出流
    CGSize keyboardSize;
    CGFloat changeHight;
}
@property (strong, nonatomic) UITextField *sendTextField;//显示
@property (strong, nonatomic) UITextView *displayView;//发送框
@property (strong, nonatomic) UIButton *connectBtn;//服务器连接
@property (strong, nonatomic) NSString *chatMsgs;//聊天消息
@end

@implementation socketTestViewController
@synthesize sendTextField;
@synthesize displayView;
@synthesize connectBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    displayView = [[UITextView alloc] initWithFrame:CGRectZero];
    displayView.editable = NO;
    displayView.backgroundColor = [UIColor blackColor];
    displayView.textColor = [UIColor whiteColor];
    [self.view addSubview:displayView];
    [displayView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(NAVIGATION_BAR_HEIGHT + 15.f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-30.f);
        make.height.mas_equalTo(SCREEN_HEIGHT/2);
    }];
    
    sendTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    sendTextField.backgroundColor = [UIColor blackColor];
    sendTextField.textColor = [UIColor whiteColor];
    sendTextField.delegate = self;
    [self.view addSubview:sendTextField];
    [self.sendTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(displayView.mas_bottom).with.offset(36.f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-30.f);
        make.height.mas_equalTo(44.f);
    }];
    
    connectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    connectBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:connectBtn];
    [connectBtn addTarget:self action:@selector(connetToHost) forControlEvents:UIControlEventTouchUpInside];
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-25.f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(44.f);
    }];
}

//聊天消息数组懒加载
- (NSString *)chatMsgs{
    if (!_chatMsgs) {
        _chatMsgs = [[NSString alloc] init];
    }
    return _chatMsgs;
}

//显示框新增消息
- (void)addMessage:(NSString *)message{
    if (message && message.length > 0) {
        NSLog(@"新增消息:\n%@\n",message);
        self.chatMsgs = [self.chatMsgs stringByAppendingString:[NSString stringWithFormat:@"%@\n",message]];
        NSLog(@"消息数组%@",self.chatMsgs);
        displayView.text = self.chatMsgs;
    }
}

#pragma UITextFieldDelegate 实现
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendData:textField.text];
    [self addMessage:[NSString stringWithFormat:@"发送的消息:%@",textField.text]];
    textField.text = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = kbSize;
    if (self.view.frame.origin.y >= 0 && ((NAVIGATION_BAR_HEIGHT + sendTextField.frame.origin.y + sendTextField.frame.size.height + keyboardSize.height - changeHight) > SCREEN_HEIGHT)) {
        [self setViewMovedUp:NAVIGATION_BAR_HEIGHT + sendTextField.frame.origin.y + sendTextField.frame.size.height + keyboardSize.height- changeHight - SCREEN_HEIGHT up:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    changeHight = 0;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)setViewMovedUp:(CGFloat)distance up:(BOOL)movedUp
{
    changeHight = distance;
    [UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        rect.origin.y -= distance;
        rect.size.height += distance;
    } else {
        rect.origin.y += distance;
        rect.size.height -= distance;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (sendTextField) {
        [sendTextField resignFirstResponder];
    }
}

#pragma NSStreamDelegate 实现
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"当前线程:[%@]",[NSThread currentThread]);
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"输入输出流打开完成");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"有字节可读");
            [self readData];
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发放字节");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"连接出现错误");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"连接结束");
            //关闭输入输出流
            [_inputStream close];
            [_outputStream close];
            //从主运行循环移除
            [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        default:
            break;
    }
}

//连接服务器
- (void)connetToHost{
    NSString *host = @"127.0.0.1";
    int port = 12345;
    //定义C语言输入输出流
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost( nil,(__bridge CFStringRef)host, port, &readStream, &writeStream);
    //C语言的输入输出流转化成oc对象 设置代理
    _inputStream = (__bridge NSInputStream *)readStream;
    _inputStream.delegate = self;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    _outputStream.delegate = self;
    // 把输入输入流添加到主运行循环
    // 不添加主运行循环 代理有可能不工作
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    // 打开输入输出流
    [_inputStream open];
    [_outputStream open];
}

//发送数据
- (void)sendData:(NSString *)content{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [_outputStream write:data.bytes maxLength:data.length];
}

//登陆
- (void)login:(id)sender{
    /* 登录
     发送用户名和密码
     在这里做的时候，只发用户名，密码就不用发送
     如果要登录，发送的数据格式为 "iam:zhangsan";
     如果要发送聊天消息，数据格式为 "msg:did you have dinner";
     */
    [self sendData:@"iam:zhangsan"];
}

//读取数据
- (void)readData{
    //建立一个缓冲区 可以放1024个字节
    uint8_t buf[1024];
    //返回实际装的字节数
    NSInteger len = [_inputStream read:buf maxLength:sizeof(buf)];
    //把字节数组转化成字符串
    NSData *data = [NSData dataWithBytes:buf length:len];
    //收到的数据
    NSString *recStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addMessage:[NSString stringWithFormat:@"收到的消息:%@",recStr]];
}

@end
