//
//  mainTabBar.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/5/8.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "mainTabBar.h"
@interface mainTabBar()
@property (nonatomic,strong) UIButton *centerBtn;
@end
@implementation mainTabBar
@synthesize centerBtn;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCenterBtn];
    }
    return self;
}

- (void)initCenterBtn{
    //设置中间按钮图片和尺寸
    centerBtn = [[UIButton alloc] init];
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"tab_center"] forState:UIControlStateNormal];
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"tab_center"] forState:UIControlStateHighlighted];
    //这里button的size是根据需要设置的中间图片来的
    CGFloat btnWidth = 45.f;
    centerBtn.layer.masksToBounds = YES;
    centerBtn.layer.cornerRadius = btnWidth/2;
    centerBtn.frame = CGRectMake(SCREEN_WIDTH/2-btnWidth/2, -btnWidth/2, btnWidth, btnWidth);
    [centerBtn addTarget:self action:@selector(centerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    Class class = NSClassFromString(@"UITabBarButton");
    NSInteger btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            btn.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.f green:(arc4random()%255)/255.f blue:(arc4random()%255)/255.f alpha:1.f];
//            //按钮宽度为TabBar宽度减去中间按钮宽度的一半
//            btn.width = (self.width - self.centerBtn.width) * 0.5;
//            //中间按钮前的宽度，这里就3个按钮，中间按钮Index为1
//            if (btnIndex < 1) {
//                btn.x = btn.width * btnIndex;
//            } else { //中间按钮后的宽度
//                btn.x = btn.width * btnIndex + self.centerBtn.width;
//            }
//            
//            btnIndex++;
//            //如果是索引是0(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来中间按钮的位置
//            if (btnIndex == 0) {
//                btnIndex++;
//            }
        }
    }

    [self bringSubviewToFront:self.centerBtn];
}

- (void)centerBtnDidClick{
    NSLog(@"中间圆形按钮被点击");
}

//重写hitTest方法，去监听中间按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        //将当前tabbar的触摸点转换坐标系，转换到中间按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.centerBtn];
        //判断如果这个新的点是在中间按钮身上，那么处理点击事件最合适的view就是中间按钮
        if ( [self.centerBtn pointInside:newP withEvent:event]) {
            return self.centerBtn;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
