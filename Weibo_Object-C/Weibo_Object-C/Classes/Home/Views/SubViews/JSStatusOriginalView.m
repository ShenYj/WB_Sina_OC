//
//  JSStatusOriginalView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusOriginalView.h"
#import "JSHomeStatusModel.h"
#import "JSHomeStatusUserModel.h"
#import "JSPictureView.h"

#pragma mark
#pragma mark -- Magic Number

static CGFloat const kHeadImageViewSize = 35.f;
static CGFloat const kMargin = 10.f;
static CGFloat const kUserStatusImageViewSize = 15.f;

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
// 用户在线状态
@property (nonatomic) UIImageView *userStatusImageView;
// 配图
@property (nonatomic) JSPictureView *pictureView;
// 记录原创微博的底边约束
@property (nonatomic) MASConstraint *selfBottomConstraint;

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self addSubview:self.userNickNameLabel];
    [self addSubview:self.userExpiredImageView];
    [self addSubview:self.userStatusImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.sourceLabel];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.pictureView];
    
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
    
    [self.userStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userExpiredImageView.mas_right).mas_offset(kMargin);
        make.size.mas_equalTo(CGSizeMake(kUserStatusImageViewSize, kUserStatusImageViewSize));
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
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom);
        make.left.mas_equalTo(self.contentLabel);
        //make.size.mas_equalTo(CGSizeMake(100, 100));迁移到PictureView内部进行约束
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.selfBottomConstraint = make.bottom.mas_equalTo(self.pictureView).mas_offset(kMargin);
    }];
    
}

#pragma mark
#pragma mark - set up data & update self bottom constraint

- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    // 用户昵称
    self.userNickNameLabel.text = statusData.user.name;
    
    // 用户头像
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:statusData.user.profile_image_url] options:YYWebImageOptionShowNetworkActivity];
    
    // 微博来源
    self.sourceLabel.text = statusData.source;
    
    // 时间
    self.timeLabel.text = statusData.created_at;
    
    // 微博内容
    self.contentLabel.text = statusData.text;
    
    // 用户状态(在线/离线)
    UserStatus status = statusData.user.userstatus;
    if (status == UserStatusOnline) {
        
        self.userStatusImageView.hidden = NO;
    } else {
        
        self.userStatusImageView.hidden = YES;
    }
    
    // 根据是否有配图,更新原创微博自身底部约束
    // 卸载约束
    [self.selfBottomConstraint uninstall];
    if (statusData.pic_urls.count > 0) {
        
        // 显示配图视图
        self.pictureView.hidden = NO;
        
        //有配图 赋值数据
        self.pictureView.statusData = statusData;
        
        // 更新约束
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.selfBottomConstraint = make.bottom.mas_equalTo(self.pictureView).mas_offset(kMargin);
        }];
        
        
    } else {
        
        // 隐藏配图视图
        self.pictureView.hidden = YES;
        
        //没有配图
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.selfBottomConstraint = make.bottom.mas_equalTo(self.contentLabel).mas_offset(kMargin);
        }];
        
    }
    
    
//    [[UIImage imageNamed:@"v2_selected"] js_cornerImageWithSize:CGSizeMake(kUserStatusImageViewSize, kUserStatusImageViewSize) fillClolor:[UIColor whiteColor] completion:^(UIImage *img) {
//        
//        UserStatus status = statusData.user.userstatus;
//        if (status == UserStatusOnline) {
//            self.userStatusImageView.image = nil;
//        } else {
//            self.userStatusImageView.image = [UIImage imageNamed:@"v2_selected"];
//        }
//    }];
    
//    UserStatus status = statusData.user.userstatus;
//    if (status == UserStatusOnline) {
//        self.userStatusImageView.image = [UIImage imageNamed:@"v2_selected"];
//    } else {
//        self.userStatusImageView.image = nil;
//    }
    
    
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
    }
    return _timeLabel;
}

- (UILabel *)sourceLabel {
    
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.font = [UIFont systemFontOfSize:10];
        _sourceLabel.textColor = [UIColor lightGrayColor];
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
    }
    return _contentLabel;
}

- (UIImageView *)userStatusImageView {
    
    if (_userStatusImageView == nil) {
        _userStatusImageView = [[UIImageView alloc] init];
        [[UIImage imageNamed:@"v2_selected"] js_cornerImageWithSize:CGSizeMake(kUserStatusImageViewSize, kUserStatusImageViewSize) fillClolor:[UIColor whiteColor] completion:^(UIImage *img) {
            _userStatusImageView.image = img;
        }];

    }
    return _userStatusImageView;
}

- (JSPictureView *)pictureView {
    
    if (_pictureView == nil) {
        _pictureView = [[JSPictureView alloc] initWithFrame:CGRectZero withPictures:self.statusData.pic_urls];
    }
    return _pictureView;
}

@end
