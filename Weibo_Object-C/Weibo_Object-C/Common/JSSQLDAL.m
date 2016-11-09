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

@implementation JSSQLDAL

+ (void)saveCache:(NSArray *)status {
    
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
            
            if (result) {
                NSLog(@"保存成功");
            } else {
                // 失败回滚
                *rollback = YES;
                NSLog(@"保存失败");
            }
        }
    }];
}

@end
