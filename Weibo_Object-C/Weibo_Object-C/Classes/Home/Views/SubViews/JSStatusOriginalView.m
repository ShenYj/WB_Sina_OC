//
//  JSStatusOriginalView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusOriginalView.h"

static CGFloat const kHeadImageViewSize = 35.f;
static CGFloat const kMargin = 10.f;


@interface JSStatusOriginalView ()

// 用户头像
@property (nonatomic) UIImageView *headImageView;
// 用户昵称
@property (nonatomic) UILabel *userNickNameLabel;
// 用户等级
@property (nonatomic) UIImageView *userExpiredImageView;
// 发布微博事件
@property (nonatomic) UILabel *timeLabel;
// 微博来源
@property (nonatomic) UILabel *sourceLabel;
// 认证图片
@property (nonatomic) UIImageView *avatarImageView;
// 微博内容
@property (nonatomic) UILabel *contentLabel;


@end

@implementation JSStatusOriginalView

- (instancetype)init {
    
    self = [super init];
    if (self) {
    
        [self prepareView];
    }
    return self;
}

#pragma mark
#pragma mark - set up UI
- (void)prepareView {
    
    self.backgroundColor = [UIColor js_randomColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.userNickNameLabel];
    [self addSubview:self.userExpiredImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.sourceLabel];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.contentLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).mas_offset(kMargin);
        make.size.mas_equalTo(CGSizeMake(kHeadImageViewSize, kHeadImageViewSize));
    }];
    
    [self.userNickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(kMargin);
        make.top.mas_equalTo(self.headImageView);
    }];
    
    [self.userExpiredImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNickNameLabel.mas_right).mas_offset(kMargin);
        make.centerY.mas_equalTo(self.userNickNameLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(kMargin);
        make.bottom.mas_equalTo(self.headImageView);
    }];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).mas_offset(kMargin);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headImageView.mas_right);
        make.centerY.mas_equalTo(self.headImageView.mas_bottom);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_offset(kMargin);
        // 通过Label的preferredMaxLayoutWidth属性限制宽度
        //make.right.mas_equalTo(self).mas_offset(-kMargin);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentLabel).mas_offset(5);
    }];
    
}

#pragma mark
#pragma mark - lazy

- (UIImageView *)headImageView {
    
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"avatar_default_small"];
    }
    return _headImageView;
}

- (UILabel *)userNickNameLabel {
    
    if (_userNickNameLabel == nil) {
        _userNickNameLabel = [[UILabel alloc] init];
        _userNickNameLabel.font = [UIFont systemFontOfSize:15];
        _userNickNameLabel.textColor = [UIColor purpleColor];
        _userNickNameLabel.text = @"一只耳";
    }
    return _userNickNameLabel;
}

- (UIImageView *)userExpiredImageView {
    
    if (_userExpiredImageView == nil) {
        _userExpiredImageView = [[UIImageView alloc] init];
        _userExpiredImageView.image = [UIImage imageNamed:@"common_icon_membership_expired"];
    }
    return _userExpiredImageView;
}

- (UILabel *)timeLabel {
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = THEME_COLOR;
        _timeLabel.text = @"时间";
    }
    return _timeLabel;
}

- (UILabel *)sourceLabel {
    
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.font = [UIFont systemFontOfSize:10];
        _sourceLabel.textColor = [UIColor lightGrayColor];
        _sourceLabel.text = @"来源";
    }
    return _sourceLabel;
}

- (UIImageView *)avatarImageView {
    
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"avatar_vip"];
    }
    return _avatarImageView;
}

- (UILabel *)contentLabel {
    
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * kMargin;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"1231231231234154kljalsdfjoipashdadfhpsalskdfdfjs;asdhjfio";
    }
    return _contentLabel;
}

@end
