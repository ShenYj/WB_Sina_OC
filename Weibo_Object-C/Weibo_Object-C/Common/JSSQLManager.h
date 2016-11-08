//
//  JSSQLManager.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/8.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface JSSQLManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic) FMDatabaseQueue *databaseQueue;

@end
