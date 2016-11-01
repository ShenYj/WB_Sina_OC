//
//  JSEmoticonToolBar.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonToolBar.h"
#import "JSEmoticonToolBarButton.h"

@interface JSEmoticonToolBar ()

// 记录选中按钮
@property (nonatomic) JSEmoticonToolBarButton *currentButton;

@end


@implementation JSEmoticonToolBar

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

// 准备视图
- (void)prepareView {
    
    self.backgroundColor = [UIColor js_randomColor];
    
    // 设置属性
    self.axis = UILayoutConstraintAxisHorizontal;
    self.distribution = UIStackViewDistributionFillEqually;
    
    // 创建button
    JSEmoticonToolBarButton *default_BT = [JSEmoticonToolBarButton creatToolBarButtonWithTitile:@"默认" withImageName:@"left" withButtonType:EmoticonToolBarButtonTypeDefault];
    JSEmoticonToolBarButton *emoji_BT = [JSEmoticonToolBarButton creatToolBarButtonWithTitile:@"Emoji" withImageName:@"mid" withButtonType:EmoticonToolBarButtonTypeEmoji];
    JSEmoticonToolBarButton *langxiaohua_BT = [JSEmoticonToolBarButton creatToolBarButtonWithTitile:@"浪小花" withImageName:@"right" withButtonType:EmoticonToolBarButtonTypeLangxiaohua];
    
    // 按钮添加点击事件
    [default_BT addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [emoji_BT addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [langxiaohua_BT addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加子控件
    [self addArrangedSubview:default_BT];
    [self addArrangedSubview:emoji_BT];
    [self addArrangedSubview:langxiaohua_BT];
    
    
}

// 自定义Toolbar按钮点击事件
- (void)clickToolBarButton:(JSEmoticonToolBarButton *)sender {
    
    if (self.currentButton == sender) {
        return;
    }
    
    self.currentButton.selected = NO;
    sender.selected = YES;
    self.currentButton = sender;
    
    if (self.clickCompeletionHandler) {
        self.clickCompeletionHandler(sender);
    }
}


@end
