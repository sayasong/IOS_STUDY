//
//  MRQRCodeViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/18.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRQRCodeViewController.h"

@interface MRQRCodeViewController ()

@end

@implementation MRQRCodeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        //矩形区域中心上移，默认中心点为屏幕中心点
        style.centerUpOffset = 44;
        //扫码框周围4个角的类型
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
        //扫码框周围4个角绘制的线条宽度
        style.photoframeLineW = 3;
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 18;
        //扫码框周围4个角的高度
        style.photoframeAngleH = 18;
        //显示矩形框
        style.isNeedShowRetangle = NO;
        //动画类型
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        UIImage *imgLine = [UIImage imageNamed:@"QRScanLine"];
        style.animationImage = imgLine;
        self.style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reStartDevice];
}

- (void)initView{
    UIButton *pickButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [pickButton setBackgroundImage:[UIImage imageNamed:@"PIC4QRCode"] forState:UIControlStateNormal];
    [pickButton addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    [pickButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *pickItem = [[UIBarButtonItem alloc] initWithCustomView:pickButton];
    self.navigationItem.rightBarButtonItems = @[ pickItem ];
}

- (void)openPhoto{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array{
    if (array.count < 1)
    {
        [self showError:NSLocalizedString(@"decode_qrcode_err", @"")];
        return;
    }
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    self.scanImage = scanResult.imgScanned;
    if (!strResult) {
        [self showError:NSLocalizedString(@"decode_qrcode_err", @"")];
        return;
    }
    //震动提醒
    [LBXScanWrapper systemVibrate];
    [self showNextVCWithScanResult:scanResult];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    NSLog(@"ScanResult :%@", strResult.strScanned);
    if (strResult.strScanned && strResult.strScanned.length>0) {
        [self handlerScanResult:strResult.strScanned];
    } else {
//        [self showError:NSLocalizedString(@"unknown_error", @"")];
//        [self reStartWhenError];
    }
}

- (void)reStartWhenError
{
    __weak typeof (self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf reStartDevice];
    });
}

- (void)handlerScanResult:(NSString *)result{
    NSLog(@"QRCode = \n%@",result);
}

@end
