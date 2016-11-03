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

// 单例
+ (instancetype)shared;

// emoticons Bundle文件
@property (nonatomic,strong) NSBundle *emoticonsBundle;

// 表情               (三维数组)
@property (nonatomic,strong) NSArray < NSArray <NSArray <JSEmoticonModel *>*> * >* allEmoticons;


@end
