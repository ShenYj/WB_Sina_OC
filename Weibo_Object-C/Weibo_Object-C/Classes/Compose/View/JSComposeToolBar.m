//
//  JSComposeToolBar.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposeToolBar.h"

static CGFloat const kHeight = 44.f;            // 自身控件高度
static NSInteger const kButtonCounts = 5;       // 子控件Button的个数

@implementation JSComposeToolBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareView];
    }
    return self;
}

/**
  准备视图
 */
- (void)prepareView {
    
    self.backgroundColor = [UIColor js_randomColor];
    
    // 设置子视图
    UIButton *pictureBbutton = [self creatToolBarButtonName:@"compose_toolbar_picture"];
    UIButton *mentionButton = [self creatToolBarButtonName:@"compose_mentionbutton_background"];
    UIButton *trendButton = [self creatToolBarButtonName:@"compose_trendbutton_background"];
    UIButton *emoticonButton = [self creatToolBarButtonName:@"compose_emoticonbutton_background"];
    UIButton *addButton = [self creatToolBarButtonName:@"compose_add_background"];
#pragma mark - 约束方式一
//    [pictureBbutton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.mas_equalTo(self);
//        make.width.mas_equalTo(mentionButton);
//    }];
//    [mentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(pictureBbutton.mas_right);
//        make.top.bottom.mas_equalTo(self);
//        make.width.mas_equalTo(trendButton);
//    }];
//    [trendButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(mentionButton.mas_right);
//        make.top.bottom.mas_equalTo(self);
//        make.width.mas_equalTo(emoticonButton);
//    }];
//    [emoticonButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(trendButton.mas_right);
//        make.top.bottom.mas_equalTo(self);
//        make.width.mas_equalTo(addButton);
//    }];
//    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(emoticonButton.mas_right);
//        make.top.bottom.mas_equalTo(self);
//        make.right.mas_equalTo(self);
//    }];
    
#pragma mark - 约束方式二
    NSArray *buttonsArr = @[pictureBbutton,mentionButton,trendButton,emoticonButton,addButton];
    [buttonsArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [buttonsArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
    }];
    
    
    // 自身控件高度
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeight);
    }];
    
}

// 创建Button
- (UIButton *)creatToolBarButtonName:(NSString *)name {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",name]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

#pragma mark 
#pragma mark - 按钮点击事件

- (void)clickToolBarButton:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
}

@end
