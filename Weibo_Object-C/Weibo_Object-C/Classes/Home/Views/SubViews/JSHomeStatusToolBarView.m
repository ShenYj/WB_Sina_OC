//
//  JSHomeStatusToolBarView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeStatusToolBarView.h"
#import "JSToolBarButton.h"

@interface JSHomeStatusToolBarView ()

// 转发
@property (nonatomic) JSToolBarButton *retweetedButton;
// 评论
@property (nonatomic) JSToolBarButton *commentButton;
// 赞
@property (nonatomic) JSToolBarButton *likeButton;
// 分割线1
@property (nonatomic) UIImageView *seperatorImageView_1;
// 分割线2
@property (nonatomic) UIImageView *seperatorImageVIew_2;
@end

@implementation JSHomeStatusToolBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self prepareViewMethod2];
    }
    return self;
}

#pragma mark 
#pragma mark - set up UI

- (void)prepareViewMethod1 {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.retweetedButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.likeButton];
    [self addSubview:self.seperatorImageView_1];
    [self addSubview:self.seperatorImageVIew_2];
    
    [self.retweetedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.commentButton);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.retweetedButton.mas_right);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.likeButton);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.commentButton.mas_right);
        make.right.mas_equalTo(self);
    }];
    
    [self.seperatorImageView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.retweetedButton.mas_right);
    }];
    
    [self.seperatorImageVIew_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.commentButton.mas_right);
    }];
    
}
- (void)prepareViewMethod2 {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.retweetedButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.likeButton];
    [self addSubview:self.seperatorImageView_1];
    [self addSubview:self.seperatorImageVIew_2];
    
    NSArray *arr = @[self.retweetedButton,self.commentButton,self.likeButton];
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self.seperatorImageView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.retweetedButton.mas_right);
    }];
    
    [self.seperatorImageVIew_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self.commentButton.mas_right);
    }];
    
}
- (void)prepareViewMethod3 {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.retweetedButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.likeButton];
    [self addSubview:self.seperatorImageView_1];
    [self addSubview:self.seperatorImageVIew_2];
    
}

#pragma mark 
#pragma mark - lazy

- (JSToolBarButton *)retweetedButton {
    
    if (_retweetedButton == nil) {
        _retweetedButton = [[JSToolBarButton alloc] initWithImageNames:@[@"timeline_icon_retweet"]];
        _retweetedButton.toolBarButtonType = JSToolBarButtonTypeRetweeted;
        [_retweetedButton setTitle:@"转发" forState:UIControlStateNormal];
    }
    return _retweetedButton;
}

- (JSToolBarButton *)commentButton {
    
    if (_commentButton == nil) {
        _commentButton = [[JSToolBarButton alloc] initWithImageNames:@[@"timeline_icon_comment"]];
        _commentButton.toolBarButtonType = JSToolBarButtonTypeComment;
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }
    return _commentButton;
}

- (JSToolBarButton *)likeButton {
    
    if (_likeButton == nil) {
        _likeButton = [[JSToolBarButton alloc] initWithImageNames:@[@"timeline_icon_unlike"]];
        _likeButton.toolBarButtonType = JSToolBarButtonTypeLike;
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    return _likeButton;
}

- (UIImageView *)seperatorImageView_1 {
    
    if (_seperatorImageView_1 == nil) {
        _seperatorImageView_1 = [[UIImageView alloc] init];
        _seperatorImageView_1.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    }
    return _seperatorImageView_1;
}

- (UIImageView *)seperatorImageVIew_2 {
    
    if (_seperatorImageVIew_2 == nil) {
        _seperatorImageVIew_2 = [[UIImageView alloc] init];
        _seperatorImageVIew_2.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    }
    return _seperatorImageVIew_2;
}

@end
