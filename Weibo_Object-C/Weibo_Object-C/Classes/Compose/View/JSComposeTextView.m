//
//  JSComposeTextView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposeTextView.h"

extern CGFloat const kMargin;

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
        make.left.top.mas_equalTo(self).mas_offset(kMargin);
    }];
}

#pragma mark 
#pragma mark - lazy
- (UILabel *)placeHolder {
    
    if (_placeHolder == nil) {
        _placeHolder = [[UILabel alloc ]init];
        _placeHolder.textColor = [UIColor lightGrayColor];
        _placeHolder.font = [UIFont systemFontOfSize:13];
        _placeHolder.text = @"输入内容...";
    }
    return _placeHolder;
}

@end
