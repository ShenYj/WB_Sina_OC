//
//  JSHomeStatusToolBarView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusToolBarView.h"
#import "JSToolBarButton.h"
#import "jSHomeStatusModel.h"

@interface JSStatusToolBarView ()

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

@implementation JSStatusToolBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self prepareViewMethod2];
    }
    return self;
}


#pragma mark 
#pragma mark - set up Data

- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    [self.retweetedButton setTitle:statusData.reposts_count_string forState:UIControlStateNormal];
    [self.commentButton setTitle:statusData.comments_count_string forState:UIControlStateNormal];
    [self.likeButton setTitle:statusData.attitudes_count_string forState:UIControlStateNormal];
    
    // 将显示内容部分的计算,放在模型中完成并保存
//    [self.retweetedButton setTitle:[self transformDisplayContentByNSNumber:statusData.reposts_count withTitle:@"转发"] forState:UIControlStateNormal];
//    [self.commentButton setTitle:[self transformDisplayContentByNSNumber:statusData.comments_count withTitle:@"评论"] forState:UIControlStateNormal];
//    [self.likeButton setTitle:[self transformDisplayContentByNSNumber:statusData.attitudes_count withTitle:@"赞"] forState:UIControlStateNormal];
}


#pragma mark - 获取转发评论赞的字符串 (将计算转移到模型类JSHomeStatusModel中完成并保存起来)
- (NSString *)transformDisplayContentByNSNumber:(NSNumber *)aNumber withTitle:(NSString *)title {
    
    /*
     - 底部toolbar 显示的转发评论赞 格式----业务需求
     - 如果 count <= 0
     - 显示格式： 转发 评论 赞 文字
     - 如果 count > 0 && count < 10000
     - 显示格式: 是多少显示多少 例如 8888  显示 8888
     - 如果 count >= 10000
     - 显示格式: x.x 万  例如 12000  显示 1.2 万
     -  例如 10000  显示 1万  20000  显示 2万 x万
     
     */
    if (aNumber.integerValue <= 0) {
        
        return title;
    } else if (aNumber.integerValue > 0 && aNumber.integerValue < 1000) {
        
        return [NSString stringWithFormat:@"%@",aNumber];
    } else {
        
        CGFloat displayFloat = aNumber.floatValue / 10000;
        NSString *displayString = [NSString stringWithFormat:@"%.1f",displayFloat];
        
        if ([displayString containsString:@".0"]) {
            
            displayString = [displayString stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        
        return [NSString stringWithFormat:@"%@万",displayString];
    }
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
        make.top.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.commentButton.mas_right);
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
    }
    return _retweetedButton;
}

- (JSToolBarButton *)commentButton {
    
    if (_commentButton == nil) {
        _commentButton = [[JSToolBarButton alloc] initWithImageNames:@[@"timeline_icon_comment"]];
        _commentButton.toolBarButtonType = JSToolBarButtonTypeComment;
    }
    return _commentButton;
}

- (JSToolBarButton *)likeButton {
    
    if (_likeButton == nil) {
        _likeButton = [[JSToolBarButton alloc] initWithImageNames:@[@"timeline_icon_unlike"]];
        _likeButton.toolBarButtonType = JSToolBarButtonTypeLike;
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
