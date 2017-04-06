//
//  lockView.h
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/4.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//
@protocol lockViewTouchesEndDelegate <NSObject>
- (void)lockViewTouchesEnd;
@end
@interface lockView : UIView
@property (nonatomic ,weak) id<lockViewTouchesEndDelegate> delegate;

@end
