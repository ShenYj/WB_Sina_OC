//
//  JSEmoticonTool.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/2.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonTool.h"
#import "JSEmoticonModel.h"

static JSEmoticonTool *_instanceType = nil;

@interface JSEmoticonTool ()

// emoticons Bundle文件
@property (nonatomic,strong) NSBundle *emoticonsBundle;





@end

@implementation JSEmoticonTool


+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc] init];
    });
    return _instanceType;
}


// 读取plist文件获取表情,返回表情一维数组
- (NSArray <JSEmoticonModel *>*)getEmoticonsWithFileName:(NSString *)fileName {
    // 拼接路径
    NSString *filePath = [NSString stringWithFormat:@"%@/info",fileName];
    // 获取完整路径
    NSString *fileFullPath = [self.emoticonsBundle pathForResource:filePath ofType:@"plist"];
    // 获取数据
    NSArray *arr = [NSArray arrayWithContentsOfFile:fileFullPath];
    
    // 遍历转模型
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSDictionary *dict in arr) {
        
        JSEmoticonModel *model = [JSEmoticonModel emoticonWithDict:dict];
       [tempArr addObject:model];
    }
    
    return tempArr.copy;
}


#pragma mark
#pragma mark - lazy

- (NSBundle *)emoticonsBundle {
    
    if (_emoticonsBundle == nil) {
        // 获取Emoticons.bundle文件的路径
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Emoticons" ofType:@"bundle"];
        // 获取bundle
        _emoticonsBundle = [NSBundle bundleWithPath:path];
    }
    return _emoticonsBundle;
}

- (NSArray<JSEmoticonModel *> *)defalut {
    
    if (_defalut == nil) {
        _defalut = [self getEmoticonsWithFileName:@"defalut"];
    }
    return _defalut;
}

- (NSArray<JSEmoticonModel *> *)emoji {
    
    if (_emoji == nil) {
        _emoji = [self getEmoticonsWithFileName:@"emoji"];
    }
    return _emoji;
}

- (NSArray<JSEmoticonModel *> *)langxiaohua {
    
    if (_langxiaohua == nil) {
        _langxiaohua = [self getEmoticonsWithFileName:@"lxh"];
    }
    return _langxiaohua;
}



@end
