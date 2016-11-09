//
//  JSSQLManager.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/8.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSSQLManager.h"

static JSSQLManager *_instanceType = nil;
static NSString * const databasePath = @"status.db";

@implementation JSSQLManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc] init];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:databasePath];
        _instanceType.databaseQueue = [[FMDatabaseQueue alloc] initWithPath:path];
        // 创建表
        [_instanceType creatTable];
    });
    return _instanceType;
}

// 创建表
- (void)creatTable {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"db.sql" ofType:nil];
    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
       
        BOOL result = [db executeStatements:sql];
        
        if (!result) {
            NSLog(@"创建表失败");
        }
        
    }];
}

// 查询表
- (NSArray *)queryTableWithSQL:(NSString *)sql {
        
    // 可变临时数组
    NSMutableArray *tempArr = [NSMutableArray array];
    
    // 执行SQL语句
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
        
        while (resultSet.next) {
        
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < resultSet.columnCount; i ++) {
                NSString *key = [resultSet columnNameForIndex:i];
                NSString *value = [resultSet objectForColumnIndex:i];
                tempDict[key] = value;
            }
            [tempArr addObject:tempDict];
        }
    }];
    
    return tempArr.copy;
    
}

@end
