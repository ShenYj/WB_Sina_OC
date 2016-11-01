//
//  JSEmoticonKeyboardView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonKeyboardView.h"
#import "JSEmoticonPageView.h"
#import "JSEmoticonToolBar.h"
#import "JSEmoticonToolBarButton.h"


static CGFloat const kEmoticonToolBarHeight = 37.f; // 表情键盘底部Toolbar高度

@interface JSEmoticonKeyboardView ()

// 表情键盘区
@property (nonatomic) JSEmoticonPageView *emoticonPageView;
// 表情键盘底部ToolBar
@property (nonatomic) JSEmoticonToolBar *emoticonToolBar;



@end

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
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
    
    // 添加子控件
    [self addSubview:self.emoticonPageView];
    [self addSubview:self.emoticonToolBar];
    // 添加约束
    
    [self.emoticonToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(kEmoticonToolBarHeight);
    }];
    
    [self.emoticonPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self.emoticonToolBar.mas_top);
    }];
    
    
    // 点击底部的ToolBar回调
    [self.emoticonToolBar setClickCompeletionHandler:^(JSEmoticonToolBarButton *button) {
        
        switch (button.toolBarButtonType) {
            case EmoticonToolBarButtonTypeDefault:
                NSLog(@"EmoticonToolBarButtonTypeDefault");
                break;
            case EmoticonToolBarButtonTypeEmoji:
                NSLog(@"EmoticonToolBarButtonTypeEmoji");
                break;
            case EmoticonToolBarButtonTypeLangxiaohua:
                NSLog(@"EmoticonToolBarButtonTypeLangxiaohua");
                break;
            default:
                break;
        }
    }];
    
}


#pragma mark
#pragma mark - lazy

- (JSEmoticonPageView *)emoticonPageView {
    
    if (_emoticonPageView == nil) {
        _emoticonPageView = [[JSEmoticonPageView alloc] init];
    }
    return _emoticonPageView;
}


- (JSEmoticonToolBar *)emoticonToolBar {
    
    if (_emoticonToolBar == nil) {
        _emoticonToolBar = [[JSEmoticonToolBar alloc] init];
    }
    return _emoticonToolBar;
}

@end
