//
//  lockView.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/4.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "lockView.h"
@interface lockView()
@property (nonatomic,strong) NSMutableArray *selectedBtns;
@property (nonatomic,assign) CGPoint currentPoint;
@end
@implementation lockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addButton];
    }
    return self;
}

//记录选中按钮的数组懒加载
- (NSMutableArray *)selectedBtns{
    if (!_selectedBtns) {
        _selectedBtns = [[NSMutableArray alloc]init];
    }
    return _selectedBtns;
}

- (void)addButton{
    //九宫格与view左右边的间距
    CGFloat interval = 10.f;
    //按钮之间的间距
    CGFloat btnInterval = 20.f;
    //按钮的尺寸
    CGFloat btnWidth = (SCREEN_WIDTH - interval *2 - btnInterval *2)/3;
    for (int index = 0; index < 9; index ++) {
        //列
        int columnNum = index%3;
        //行
        int lineNum = index/3;
        NSLog(@"(%d,%d)\n",columnNum,lineNum);
        /*
         interval (0,0) btnInterval (1,0) btnInterval (2,0) interval
         (0,1) (1,1) (2,1)
         (0,2) (1,2) (2,2)
         */
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = index;
        btn.frame = CGRectMake(interval + columnNum*btnWidth +columnNum*btnInterval, (SCREEN_HEIGHT - SCREEN_WIDTH)/2 + interval + lineNum*btnWidth +lineNum*btnInterval, btnWidth, btnWidth);
        btn.backgroundColor = [UIColor clearColor];
        [btn setBackgroundImage:[UIImage imageNamed:@"lock_btn_unselected"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"lock_btn_selected"] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
    }
}

#pragma 触摸方法:连线效果的实现
//拿到触摸的点
- (CGPoint)pointWithTouch:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];//self 可以换成touch.view
    return point;
}

//根据触摸的点拿到响应的按钮
- (UIButton *)buttonWithPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews){
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self pointWithTouch:touches];
    UIButton *btn = [self buttonWithPoint:point];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedBtns addObject:btn];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self pointWithTouch:touches];
    UIButton *btn = [self buttonWithPoint:point];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedBtns addObject:btn];
    }
    //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    else{
        //已经被选中的按钮 不会走进上一个流程被加入数组中 会导致没有办法重复连线
        self.currentPoint = point;
    }
    [self setNeedsDisplay];//调用drawrect方法
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //这里让所有选中效果消失
    //[self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:[NSNumber numberWithBool:NO]];
    for (UIView * subview in self.subviews) {
        if ([subview class] == [UIButton class]) {
            UIButton *btn = (UIButton *)subview;
            [btn setSelected:NO];
        }
    }
    [self.selectedBtns removeAllObjects];
    [self setNeedsDisplay];//调用drawrect方法
    NSLog(@"锁屏界面准备消失");
    if (self.delegate && [self.delegate respondsToSelector:@selector(lockViewTouchesEnd)]) {
        [self.delegate lockViewTouchesEnd];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect{
    if (self.selectedBtns.count == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 8;
    path.lineJoinStyle = kCGLineCapRound;
    [[UIColor blackColor] set];
    for (int i = 0; i < self.selectedBtns.count; i ++) {
        UIButton *btn = self.selectedBtns[i];
        if (i == 0) {//起点
            [path moveToPoint:btn.center];
        }else{//连线
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}

@end
