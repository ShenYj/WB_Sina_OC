//
//  JSComposeToolBar.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposeToolBar.h"
#import "JSComposeToolBarButton.h"

static CGFloat const kHeight = 44.f;            // 自身控件高度
static NSInteger const kButtonCounts = 5;       // 子控件Button的个数

@interface JSComposeToolBar ()

@end

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 设置子视图
    JSComposeToolBarButton *pictureBbutton = [self creatToolBarButtonName:@"compose_toolbar_picture"withButtonType:JSComposeToolBarTypePicture];
    JSComposeToolBarButton *mentionButton = [self creatToolBarButtonName:@"compose_mentionbutton_background"withButtonType:JSComposeToolBarTypeMention];
    JSComposeToolBarButton *trendButton = [self creatToolBarButtonName:@"compose_trendbutton_background"withButtonType:JSComposeToolBarTypeTrend];
    JSComposeToolBarButton *emoticonButton = [self creatToolBarButtonName:@"compose_emoticonbutton_background"withButtonType:JSComposeToolBarTypeEmoticon];
    JSComposeToolBarButton *addButton = [self creatToolBarButtonName:@"compose_add_background"withButtonType:JSComposeToolBarTypeAdd];
    
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

// 创建Button公共方法
- (JSComposeToolBarButton *)creatToolBarButtonName:(NSString *)name withButtonType:(JSComposeToolBarType)buttonType{
    JSComposeToolBarButton *button = [[JSComposeToolBarButton alloc] init];
    button.toolBarButtonType = buttonType;
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",name]] forState:UIControlStateHighlighted];
    [self addSubview:button];
    return button;
}

#pragma mark 
#pragma mark - 按钮点击事件



@end
