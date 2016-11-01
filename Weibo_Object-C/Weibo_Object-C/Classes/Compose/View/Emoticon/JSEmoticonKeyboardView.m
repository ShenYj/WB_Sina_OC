//
//  JSEmoticonKeyboardView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonKeyboardView.h"

@implementation JSEmoticonKeyboardView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

// 准备视图
- (void)prepareView {
    // 设置背景色
    self.backgroundColor = [UIColor js_randomColor];
    
    
}

@end
