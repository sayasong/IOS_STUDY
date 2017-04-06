//
//  JWGifFrame.h
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/20.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWGifFrame : NSObject
@property (nonatomic,assign) NSUInteger index;  /**< 表示第几帧 */

@property (nonatomic,assign) NSTimeInterval duration;   /**< 持续时间 */

@property (nonatomic,strong) UIImage *image;    /**< 图片 */
@end
