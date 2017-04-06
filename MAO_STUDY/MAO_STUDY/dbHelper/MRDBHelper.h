//
//  MRDBHelper.h
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/10.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRDBHelper : NSObject
+(MRDBHelper *)shareInstance;
//查
- (NSInteger)getAllTextCount;
- (NSInteger)getAllUserCount;
- (NSArray *)getModelsFormTableWithSql:(NSString *)sqlStr andValues:(NSArray *)values andTableName:(NSString *)tableName;
//增
- (void)insertIntoTable:(NSString *)table withObjects:(NSArray *)objects;
//删
-(void)deleteFromTable:(NSString *)table withConditionsfield:(NSArray *)fields andConditions:(NSArray *)values;
- (void)deleteAllFromTable:(NSString *)tableName;
//改 懒得写自动解析的了 这里填入整条sql语句
- (void)updateInTableWithSql:(NSString *)sqlStr andValues:(NSArray *)values;
@end
