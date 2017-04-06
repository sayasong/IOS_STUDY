//
//  snowView.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/14.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "snowView.h"

@implementation snowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initEmitterLayerProperties];
    }
    return self;
}

- (void)initEmitterLayerProperties{
    self.emitterLayer.masksToBounds = YES;
    self.emitterLayer.emitterShape = kCAEmitterLayerLine;
    self.emitterLayer.emitterMode = kCAEmitterLayerSurface;
    self.emitterLayer.emitterSize = self.frame.size;
    self.emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2.f, -20.f);
}

- (void)show{
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    snowflake.birthRate = 1.f;
    snowflake.speed = 10.f;
    snowflake.velocity = 2.f;
    snowflake.velocityRange = 10.f;
    snowflake.yAcceleration = 10.f;
    snowflake.emissionRange = 0.5 * M_PI;
    snowflake.spinRange = 0.25 * M_PI;
    snowflake.contents = (__bridge id)([UIImage imageNamed:@"snow"].CGImage);
    snowflake.color = [UIColor redColor].CGColor;
    snowflake.lifetime = 60.f;
    snowflake.scale = 0.5f;
    snowflake.scaleRange = 0.3;
    
    self.emitterLayer.emitterCells = @[snowflake];
}

- (void)hide{
    
}

@end
