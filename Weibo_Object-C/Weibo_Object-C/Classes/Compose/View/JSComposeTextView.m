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

@interface JSComposeTextView ()
// 占位文字Label
@property (nonatomic) UILabel *placeHolder;
@end


@implementation JSComposeTextView

// 构造函数
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    // 监听通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeTextViewValueChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}

// 设置占位文字Label字体大小
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolder.font = font;
}

// 设置占位文字Label文字
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeHolder.text = placeholder;
}

// 设置占位文字Label显隐
- (void)setPlaceholderHidden:(BOOL)placeholderHidden {
    _placeholderHidden = placeholderHidden;
    self.placeHolder.hidden = placeholderHidden;
}

/**
 监听到JSComposeTextView的值发生变化后执行的方法
 */
//- (void)composeTextViewValueChanged:(NSNotification *)notification {
//    
//    self.placeHolder.hidden = ((JSComposeTextView *)notification.object).hasText;
//}

#pragma mark 
#pragma mark - lazy
- (UILabel *)placeHolder {
    
    if (_placeHolder == nil) {
        _placeHolder = [[UILabel alloc ]init];
        _placeHolder.numberOfLines = 0;
        _placeHolder.textColor = [UIColor lightGrayColor];
        
    }
    return _placeHolder;
}

@end
