//
//  JSVistorView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/26.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSVistorView.h"


@interface JSVistorView ()

@property (nonatomic,strong) UIImageView *circleImageView;
@property (nonatomic,strong) UIImageView *maskImageView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *registerButton;
@end

@implementation JSVistorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskImageView.mas_bottom).mas_offset(16);
        make.centerX.mas_equalTo(self);
        make.width.mas_offset(224);
        make.height.mas_offset(36);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageLabel.mas_bottom).mas_offset(16);
        make.width.mas_offset(100);
        make.height.mas_offset(36);
        make.leading.mas_equalTo(self.messageLabel);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.messageLabel);
        make.height.mas_equalTo(self.loginButton);
        make.width.mas_equalTo(self.loginButton);
        make.top.mas_equalTo(self.loginButton);
    }];
    
}
- (void)setupUI{
    
    [self addSubview:self.circleImageView];
    [self addSubview:self.maskImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.loginButton];
    [self addSubview:self.registerButton];
    
}

- (void)setupVistorViewInfoWithTitle:(NSString *)title withImageName:(NSString *)imageName{
    
    if (title == nil && imageName == nil) {
        
        //设置主页控制器动画
        [self setAnimation];
        
    }else{
        //设置控制器信息
        self.circleImageView.alpha = 0.01;
        self.iconImageView.image = [UIImage imageNamed:imageName];
        self.messageLabel.text = title;
    }
    
}

/**
 *  设置主页控制器动画
 */
- (void)setAnimation{
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.toValue = @(M_PI * 2);
    basicAnimation.duration = 10;
    basicAnimation.repeatCount = MAXFLOAT;
    basicAnimation.removedOnCompletion = NO;
    [self.circleImageView.layer addAnimation:basicAnimation forKey:nil];
}

//按钮点击事件
- (void)buttonClick:(UIButton *)sender{
    
    self.finishedBlock();
    
}


- (UIImageView *)circleImageView {
    
    if (_circleImageView == nil) {
        
        _circleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_smallicon"]];
    }
    return _circleImageView;
}

- (UIImageView *)maskImageView {
    
    if (_maskImageView == nil) {
        _maskImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"]];
    }
    return _maskImageView;
}

- (UIImageView *)iconImageView {
    
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
    }
    return _iconImageView;
}

- (UILabel *)messageLabel {
    
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.text = @"关注一些人，回这里看看有什么惊喜关注一些人";
        _messageLabel.textColor = THEME_COLOR;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)loginButton {
    
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    
    if (_registerButton == nil) {
        _registerButton = [[UIButton alloc]init];
        [_registerButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}
@end
