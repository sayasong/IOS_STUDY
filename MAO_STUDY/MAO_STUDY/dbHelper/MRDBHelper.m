//
//  MRDBHelper.m
//  MAO_STUDY
//
//  Created by 毛睿 on 17/1/10.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//
/*
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentDirectory = [paths objectAtIndex:0];
 */
#import "MRDBHelper.h"

//建表的字符串 拼上表名 和 字段名
NSString *const CREATE_USER_TABLE_FORMAT = @"create table if not exists %@ (id integer primary key autoincrement,%@ text,%@ text)";
NSString *const CREATE_TEXT_TABLE_FORMAT = @"create table if not exists %@ (id integer primary key autoincrement,%@ text,%@ text)";

@interface MRDBHelper()
@property (nonatomic ,strong) FMDatabaseQueue *dbQueue;
@end
@implementation MRDBHelper

+(MRDBHelper *)shareInstance{
    static MRDBHelper *dbHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbHelper = [[self alloc] init];
    });
    return dbHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化数据库处理队列
        NSString *pathStr = [NSString stringWithFormat:@"%@/Documents/MR_DB.db",NSHomeDirectory()];
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:pathStr];
        [self createTable];
    }
    return self;
}

#pragma 建表 需要在初始化中完成
- (void)createTable{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
        [db executeUpdate:[NSString stringWithFormat:CREATE_TEXT_TABLE_FORMAT,TEXT_TABLE_NAME,TEXT_TITLE,TEXT_CONTENT]];
        [db executeUpdate:[NSString stringWithFormat:CREATE_USER_TABLE_FORMAT,USER_TABLE_NAME,USER_USERNAME,USER_LOCKPASSWORD]];
        if (rollback) {
            NSLog(@"create tables success");
        }else{
            NSLog(@"create tables failed");
        }
    }];
}

#pragma 表 查 inDatabase
- (NSInteger)getCountFromTableWithTableName:(NSString *)tableName{
    __block int count = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db){
        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"select count(*) from %@",tableName]];
        if ([res next]) {
            count = [res intForColumnIndex:0];
        }
        [res close];
    }];
    return count;
}

- (NSInteger)getAllTextCount{
    return [self getCountFromTableWithTableName:TEXT_TABLE_NAME];
}

- (NSInteger)getAllUserCount{
    return [self getCountFromTableWithTableName:USER_TABLE_NAME];
}

- (NSArray *)getModelsFormTableWithSql:(NSString *)sqlStr andValues:(NSArray *)values andTableName:(NSString *)tableName{
    __block NSMutableArray *resArray = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db){
        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:values];
        if ([tableName isEqualToString:USER_TABLE_NAME]) {
            while ([resultSet next]) {
                MRUser *user = [[MRUser alloc] init];
                user.userName = [resultSet stringForColumn:USER_USERNAME];
                user.lockPassword = [resultSet stringForColumn:USER_LOCKPASSWORD];
                [resArray addObject:user];
            }
        }else if ([tableName isEqualToString:TEXT_TABLE_NAME]){
            while ([resultSet next]) {
                MRText *text = [[MRText alloc] init];
                text.title = [resultSet stringForColumn:TEXT_TITLE];
                text.content = [resultSet stringForColumn:TEXT_CONTENT];
                [resArray addObject:text];
            }
        }
        [resultSet close];
    }];
    return resArray;
}
#pragma 表 数据插入 inDatabase
- (void)insertIntoTable:(NSString *)table withObjects:(NSArray *)objects{
    for (int index = 0; index < [objects count]; index ++) {
        [self insertIntoTable:table withObject:objects[index]];
    }
}

- (void)insertIntoTable:(NSString *)table withObject:(NSObject *)object{
    if ([table isEqualToString:USER_TABLE_NAME]) {
        NSString * sqlStr = [NSString stringWithFormat:@"insert into %@ (%@, %@) values(?, ?)",
                             table,USER_USERNAME,USER_LOCKPASSWORD];
        MRUser *user = (MRUser *)object;
        [self.dbQueue inDatabase:^(FMDatabase *db){
            [db executeUpdate:sqlStr,user.userName,user.lockPassword];
        }];
    }else if ([table isEqualToString:TEXT_TABLE_NAME]){
        NSString * sqlStr = [NSString stringWithFormat:@"insert into %@ (%@, %@) values(?, ?)",
                             table,TEXT_TITLE,TEXT_CONTENT];
        MRText *text = (MRText *)object;
        [self.dbQueue inDatabase:^(FMDatabase *db){
            [db executeUpdate:sqlStr,text.title,text.content];
        }];
    }else{
        NSLog(@"error:不存在的表");
    }
}

#pragma 表 删除满足某个条件的数据 inTransaction
/*
 * 入参1: [NSString stringWithFormat:@"%@ = ?",字段名]
 * 入参2: 字段更新之后的值 也就是model的属性
 * [db executeUpdate:delsql withArgumentsInArray:values]; 入参1:delete from USER_TABLE where username = ?
 */
-(void)deleteFromTable:(NSString *)table withConditionsfield:(NSArray *)fields andConditions:(NSArray *)values{
    NSMutableString *sqlStr = [NSMutableString new];
    [sqlStr appendString:@""];
    
    if(fields && fields.count >0 ){
        [sqlStr appendString:@" where "];
        for (int index = 0; index < fields.count; index ++) {
            [sqlStr appendString:fields[index]];
            if (index < (fields.count - 1)) {
                [sqlStr appendString:@" and "];
            }
        }
    }
    NSString * delsql = [NSString stringWithFormat:@"delete from %@%@",table,sqlStr];
    //delete from tablename where 字段 = ? and 字段 = ?
    [self.dbQueue inTransaction:^(FMDatabase* db,BOOL* rback){
        [db executeUpdate:delsql withArgumentsInArray:values];
        if (rback) {
            NSLog(@"del sql success %@",delsql);
        }else{
            NSLog(@"del sql fail");
        }
    }];
}

- (void)deleteAllFromTable:(NSString *)tableName{
    NSString * clearsql = [NSString stringWithFormat:@"delete from %@",tableName];
    [self.dbQueue inTransaction:^(FMDatabase* db,BOOL* rback){
        [db executeUpdate:clearsql];
    }];
}

#pragma 表 改
//update student set name='caoyu' where number=1
- (void)updateInTableWithSql:(NSString *)sqlStr andValues:(NSArray *)values{
    [self.dbQueue inTransaction:^(FMDatabase* db,BOOL* rback){
        [db executeUpdate:sqlStr withArgumentsInArray:values];
        if (rback) {
            NSLog(@"update sql success %@",sqlStr);
        }else{
            NSLog(@"update sql fail");
        }
    }];
}

@end
