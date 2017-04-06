//
//  lockWindow.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/7.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "lockWindow.h"
#import "lockView.h"
@interface lockWindow()<lockViewTouchesEndDelegate>
@property (nonatomic,strong) UIWindow *coverWindow;
@property (nonatomic,strong) lockView *mlockView;
@end
@implementation lockWindow

- (UIWindow *)coverWindow{
    if (!_coverWindow) {
        _coverWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _coverWindow;
}

- (lockView *)mlockView{
    if (!_mlockView) {
        _mlockView = [[lockView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _mlockView;
}

- (void)show{
    self.coverWindow.backgroundColor = [UIColor clearColor];
    self.coverWindow.windowLevel = MAX_WINDOW_LEVEL;
    [self.coverWindow addSubview:self.mlockView];
    self.mlockView.delegate = self;
    [self.coverWindow makeKeyAndVisible];
}

- (void)hide{
    [self.coverWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.coverWindow resignKeyWindow];
    [self.coverWindow setHidden:YES];
    self.coverWindow = nil;
}

- (void)lockViewTouchesEnd{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

@end
