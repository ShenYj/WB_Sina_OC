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

NSInteger const kEmoticonsRowCount = 3;  // 表情键盘中表情行数
NSInteger const kEmoticonsColCount = 7;  // 表情键盘中表情列数
NSInteger maxEmoticonCounts;             // 表情键盘每页最大数

@interface JSEmoticonTool ()

// emoji表情          (一维数组)
@property (nonatomic,strong) NSArray <JSEmoticonModel *>*emoji;
// langxiaohua表情    (一维数组)
@property (nonatomic,strong) NSArray <JSEmoticonModel *>*langxiaohua;
// default表情        (一维数组)
@property (nonatomic,strong) NSArray <JSEmoticonModel *>*defalut;



@end

@implementation JSEmoticonTool


+ (void)load {
    // 计算表情键盘每一页最多展示表情个数
    maxEmoticonCounts = kEmoticonsColCount * kEmoticonsRowCount - 1;
}

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc] init];
    });
    return _instanceType;
}

// 遍历一维数组,转二维数组
- (NSArray <NSArray <JSEmoticonModel *>*> *)getEmoticonGroupWithEmoticons:(NSArray <JSEmoticonModel *>*)emocitons {
    
    // 临时可变数组
    NSMutableArray <NSArray <JSEmoticonModel *>*> *tempArr = [NSMutableArray array];
    
    // 计算表情一维数组的页数
    NSInteger pageCount = (emocitons.count + maxEmoticonCounts - 1) / maxEmoticonCounts;
    for (int i = 0; i < pageCount; i ++) {
        
        NSInteger loc = i * maxEmoticonCounts;
        NSInteger len = maxEmoticonCounts;
        
        // 防止越界
        if (loc + len > emocitons.count) {
            len = emocitons.count - loc;
        }
        
        NSRange range = NSMakeRange(loc, len);
        
        NSArray <JSEmoticonModel *>*arr = [emocitons subarrayWithRange:range];
        [tempArr addObject:arr];
    }
    
    return tempArr.copy;
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
        // 缓存表情包路径 
        [model setValue:[NSString stringWithFormat:@"%@",fileName] forKey:@"path"];
        
       [tempArr addObject:model];
    }
    
    return tempArr.copy;
}

// 通过chs(表情描述)查找对应的表情模型对象
- (JSEmoticonModel *)searchEmoticonChs:(NSString *)chs {
    
    // 遍历默认表情
    for (JSEmoticonModel *model in self.defalut) {
        
        if ([model.chs isEqualToString:chs]) {
            return model;
        }
    }
    // 遍历浪小花表情
    for (JSEmoticonModel *model in self.langxiaohua) {
        
        if ([model.chs isEqualToString:model.chs]) {
            return model;
        }
    }
    
    return nil;
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
        _defalut = [self getEmoticonsWithFileName:@"default"];
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

- (NSArray < NSArray <NSArray <JSEmoticonModel *>*> * > *)allEmoticons {
    
    if (_allEmoticons == nil) {
        _allEmoticons = @[
                       [self getEmoticonGroupWithEmoticons:self.defalut],
                       [self getEmoticonGroupWithEmoticons:self.emoji],
                       [self getEmoticonGroupWithEmoticons:self.langxiaohua]
                       ];
    }
    return _allEmoticons;
}

@end
