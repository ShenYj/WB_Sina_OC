//
//  JSStatusRetweetView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusRetweetView.h"
#import "JSHomeStatusModel.h"
#import "JSPictureView.h"

static CGFloat const kRetweetContentLabelFontSize = 13.f;

static CGFloat const kMargin = 10.f;

@interface JSStatusRetweetView ()

// 转发微博中的微博内容
@property (nonatomic) UILabel *contentLabel;
// 转发微博中的配图
@property (nonatomic) JSPictureView *pictureView;
// 记录转发微博底部约束
@property (assign,nonatomic) MASConstraint *selfBottomConstraint;

@end

@implementation JSStatusRetweetView

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
    
    self.backgroundColor = [UIColor js_colorWithHex:0xE8E8E8];
    
    [self addSubview:self.contentLabel];
    [self addSubview:self.pictureView];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(kMargin);
        make.top.mas_equalTo(self).mas_offset(kMargin);
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(kMargin);
        make.left.mas_equalTo(self.contentLabel);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.selfBottomConstraint = make.bottom.mas_equalTo(self.pictureView).mas_offset(kMargin);
    }];
    
}

#pragma mark
#pragma mark - set up Data

- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    // 设置转发微博内容
    self.contentLabel.text = statusData.text;
    // 设置转发微博配图
    [self.selfBottomConstraint uninstall];
    if (statusData.pic_urls.count > 0) {
        // 转发微博有配图
        self.pictureView.hidden = NO;
        // 传递数据
        self.pictureView.statusData = statusData;
        // 更新约束
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.selfBottomConstraint = make.bottom.mas_equalTo(self.pictureView).mas_offset(kMargin);
        }];
        
    } else {
        // 转发微博没有配图
        self.pictureView.hidden = YES;
        // 更新约束
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.selfBottomConstraint = make.bottom.mas_equalTo(self.contentLabel).mas_offset(kMargin);
        }];
        
    }
    
}


#pragma mark
#pragma mark - lazy

- (UILabel *)contentLabel {
    
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:kRetweetContentLabelFontSize];
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * kMargin;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (JSPictureView *)pictureView {
    
    if (_pictureView == nil) {
        _pictureView = [[JSPictureView alloc] init];
    }
    return _pictureView;
}

@end
