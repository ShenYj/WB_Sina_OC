//
//  JSComposeTextView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposeTextView.h"

static CGFloat const kMarginTop = 8.f; // 占位文字顶部间距
static CGFloat const kMarginLeft = 5.f;// 占位文字左侧间距


@implementation JSComposeTextView

// 构造函数
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

// 设置视图
- (void)prepareView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.placeHolder];
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(kMarginLeft);
        make.top.mas_equalTo(self).mas_offset(kMarginTop);
        make.width.mas_equalTo(SCREEN_WIDTH - 2*kMarginLeft);
    }];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolder.font = font;
    
}

#pragma mark 
#pragma mark - lazy
- (UILabel *)placeHolder {
    
    if (_placeHolder == nil) {
        _placeHolder = [[UILabel alloc ]init];
        _placeHolder.textColor = [UIColor lightGrayColor];
        _placeHolder.text = @"我的天空今天有点灰...";
    }
    return _placeHolder;
}

@end
