//
//  mrBaseEmitterLayerView.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/14.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "mrBaseEmitterLayerView.h"
@interface mrBaseEmitterLayerView(){
    CAEmitterLayer *_emitterLayer;
}
@end
@implementation mrBaseEmitterLayerView

+ (Class)layerClass{
    return [CAEmitterLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emitterLayer = (CAEmitterLayer *)self.layer;
    }
    return self;
}

- (void)setEmitterLayer:(CAEmitterLayer *)layer{
    _emitterLayer = layer;
}

- (CAEmitterLayer *)emitterLayer{
    return _emitterLayer;
}

- (void)show{
    
}

- (void)hide{
    
}

@end
