//
//  JSComposeButton.m
//  ComposeView
//
//  Created by ShenYj on 2016/12/9.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

#import "JSComposeButton.h"
#import "Masonry.h"

@interface JSComposeButton ()

@property (nonatomic) UIImageView *js_ImageView;
@property (nonatomic) UILabel *js_Label;

@end

@implementation JSComposeButton

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        [self prepareComposeButtonViewWithTitle:(NSString *)title imageName:(NSString *)imageName];
    }
    return self;
}

- (void)prepareComposeButtonViewWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.js_ImageView];
    [self addSubview:self.js_Label];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.js_ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.js_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.js_ImageView.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
    
    self.js_ImageView.image = [UIImage imageNamed:imageName];
    self.js_Label.text = title;
    
}

#pragma mark 
#pragma mark - lazy

- (UIImageView *)js_ImageView {
    if (!_js_ImageView) {
        _js_ImageView = [[UIImageView alloc] init];
    }
    return _js_ImageView;
}

- (UILabel *)js_Label {
    if (!_js_Label) {
        _js_Label = [[UILabel alloc] init];
        _js_Label.font = [UIFont systemFontOfSize:16];
    }
    return _js_Label;
}

@end
