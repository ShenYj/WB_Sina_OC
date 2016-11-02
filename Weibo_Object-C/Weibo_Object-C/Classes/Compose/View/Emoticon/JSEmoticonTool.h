//
//  JSEmoticonTool.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/2.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSEmoticonModel;

@interface JSEmoticonTool : NSObject

// default表情        (一维数组)
@property (nonatomic,strong) NSArray <JSEmoticonModel *>*defalut;
// emoji表情          (一维数组)
@property (nonatomic,strong) NSArray <JSEmoticonModel *>*emoji;
// langxiaohua表情    (一维数组)
@property (nonatomic,strong) NSArray <JSEmoticonModel *>*langxiaohua;

+ (instancetype)shared;

@end
