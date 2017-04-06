//
//  JWGifDecoder.h
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/20.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWGifFrame.h"

@interface JWGifDecoder : NSObject

@property (nonatomic,readonly) NSData *data;    /**< 图片数据 */

@property (nonatomic,readonly) NSInteger loopCount; /**< 循环次数 */

@property (nonatomic,readonly) NSUInteger frameCount;   /**< 帧数 */

/**
 根据图片数据生成加码对象，当data为nil，返回nil
 
 @param data GIF图片数据
 
 @return 解码对象
 */
+ (instancetype) decoderWithData:(NSData *)data;

/**
 获取对应索引值的帧
 
 @param index 索引值
 
 @return 帧对象
 */
- (JWGifFrame *) frameAtIndex:(NSUInteger)index;

@end
