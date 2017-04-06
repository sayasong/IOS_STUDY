//
//  ClientModel.h
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/20.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientModel : NSObject

@property(nonatomic,assign)int clientSocket;
@property(nonatomic,copy) NSString *clientName;

@end
