//
//  JSStatusRetweetView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusRetweetView.h"
#import "JSHomeStatusModel.h"

static CGFloat const kMargin = 10.f;

@interface JSStatusRetweetView ()

// 转发微博中的微博内容
@property (nonatomic) UILabel *contentLabel;

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
    
    self.backgroundColor = [UIColor js_randomColor];
    
    [self addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(kMargin);
        make.top.mas_equalTo(self).mas_offset(kMargin);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentLabel).mas_offset(kMargin);
    }];
    
}

#pragma mark
#pragma mark - set up Data

- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    self.contentLabel.text = statusData.retweeted_status.text;
    
}

#pragma mark
#pragma mark - lazy

- (UILabel *)contentLabel {
    
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * kMargin;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
