//
//  JSSQLDAL.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/9.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSSQLDAL.h"
#import "JSUserAccountTool.h"
#import "JSSQLManager.h"
#import "JSHomeStatusModel.h"
#import "JSNetworkTool.h"
#import "JSDateFormatter.h"
#import "NSString+JSAppendPath.h"

static double kExpiredCycle = -60*60*24*7; // 默认一周

@implementation JSSQLDAL

+ (void)saveCache:(NSArray <NSDictionary *>*)status {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *userid = [JSUserAccountTool sharedManager].userAccountModel.uid;
        if (!userid) {
            return;
        }
        
        NSString *sql = @"INSERT OR REPLACE INTO T_Status (statusid,status,userid) VALUES (?,?,?)";
        // 执行sql
        [[JSSQLManager sharedManager].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            // 循环
            for (NSDictionary *dict in status) {
                
                NSInteger statusid = (NSInteger)dict[@"id"];
                
                NSError *error = nil;
                NSData *status = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
                
                if (error) {
                    NSLog(@"序列化出错:%@",error);
                }
                
                BOOL result = [db executeUpdate:sql withArgumentsInArray:@[@(statusid),status,userid]];
                
                if (!result) {
                    
                    // 失败回滚
                    *rollback = YES;
                    NSLog(@"保存失败");
                }
            }
        }];
    });
    
}

+ (NSArray <JSHomeStatusModel *>*)getLocalCacheWithSinceid:(NSInteger)sinceId withMaxId:(NSInteger)maxId {
    
    NSInteger userid = [JSUserAccountTool sharedManager].userAccountModel.uid.integerValue;
    
    // 如果用户没有登录,直接返回
    if (!userid) {
        return nil;
    }
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM T_Status WHERE userid = %zd",userid];
    
    if (sinceId > 0) {
        // 下拉刷新
        //sql = [NSString stringWithFormat:@"SELECT * FROM T_Status WHERE userid = %zd AND statusid > %zd ORDER BY statusid DESC LIMIT 20",userid,sinceId];
        [sql appendString:[NSString stringWithFormat:@" AND statusid > %zd",sinceId]];
        
    } else {
        // 上拉加载更多
        //sql = [NSString stringWithFormat:@"SELECT * FROM T_Status WHERE userid = %zd AND statusid <= %zd ORDER BY statusid DESC LIMIT 20",userid,maxId];
        [sql appendString:[NSString stringWithFormat:@" AND statusid <= %zd",maxId]];
    }
    [sql appendString:@" ORDER BY statusid DESC LIMIT 20"];
    
    // 查询数据
    NSArray <NSDictionary *>*result = [[JSSQLManager sharedManager] queryTableWithSQL:sql.copy];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSDictionary *dict in result) {
        
        NSData *statusData = dict[@"status"];
        NSError *error = nil;
        NSDictionary *status = [NSJSONSerialization JSONObjectWithData:statusData options:0 error:&error];
        
        // 字典转模型
        JSHomeStatusModel *statusModel = [JSHomeStatusModel statuWithDict:status];
        
        [tempArr addObject:statusModel];
        
    }
    
    return tempArr.copy;
    
}


// 检查本地是否有缓存数据
+ (void)checkLocalCacheWithSinceid:(NSInteger)sinceId withMaxid:(NSInteger)maxId withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
    NSArray *localCache = [self getLocalCacheWithSinceid:sinceId withMaxId:maxId];
    
    if (localCache.count > 0) {
        // 本地有缓存数据
        finishedBlock(localCache,nil);
        
        
    } else {
        // 本地没有数据
        [[JSNetworkTool sharedNetworkTool] loadHomePublicDatawithFinishedBlock:^(id obj, NSError *error) {
            
            NSArray <NSDictionary *>*statusDataArr = (NSArray <NSDictionary *>*)obj;
            
            // 数据库存储(异步执行)
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self saveCache:statusDataArr];
            });
            
            NSMutableArray *mArr = [NSMutableArray array];
            
            for (NSDictionary *dict in statusDataArr) {
                
                JSHomeStatusModel *model = [JSHomeStatusModel statuWithDict:dict];
                [mArr addObject:model];
                
            }
            // 完成回调
            finishedBlock(mArr.copy,error);
            
        } Since_id:sinceId max_id:maxId];
    }
    
}


+ (void)deleteCache {
    
    JSUserAccountModel *userAccountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString getDocumentDirectoryPath]];
    
    // 过期时间到当前时间的临界值 (一周前)
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:@(userAccountModel.expiredCycle).doubleValue];
    
    [JSDateFormatter sharedDateFormatterManager].dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [[JSDateFormatter sharedDateFormatterManager] stringFromDate:date];
    
    // 删除距离当前时间一周前的数据
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_Status WHERE createtime < '%@'",dateString];
    
    [[JSSQLManager sharedManager].databaseQueue inDatabase:^(FMDatabase *db) {
       
        BOOL result = [db executeUpdate:sql withArgumentsInArray:nil];
        
        if (!result) {
            NSLog(@"删除失败");
        }
        
    }];
    
    
}



@end
