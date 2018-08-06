//
//  JSTabBar.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/25.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSTabBar.h"
#import "Masonry.h"

@interface JSTabBar ()
@property (nonatomic,strong) UIButton *composeButton;
@end

@implementation JSTabBar

- (instancetype)init {
    self = [super init];
    if (self) {
        //设置UI
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.composeButton];
    [self.composeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 5;
    CGFloat index = 0;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            CGRect frame     = view.frame;
            frame.size.width = width;
            frame.origin.x   = index * width;
            view.frame       = frame;
            
            index ++;
            if (index == 2) index ++;
        }
    }
}

//按钮点击事件中调用代理方法
- (void)buttonClick:(UIButton *)sender {
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDelegateWithTabBar:)]) {
        [self.tabBarDelegate tabBarDelegateWithTabBar:self];
    }
}

/**
 *  ComposeButton懒加载
 *
 *  @return composeButton
 */
- (UIButton *)composeButton {
    if (_composeButton == nil) {
        _composeButton = [[UIButton alloc]init];
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [_composeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [_composeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [_composeButton sizeToFit];
        [_composeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _composeButton;
}

@end
