//
//  JSStatusCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusCell.h"
#import "JSHomeStatusModel.h"
#import "JSStatusOriginalView.h"
#import "JSStatusRetweetView.h"
#import "JSStatusToolBarView.h"


extern CGFloat const kTopMargin;
extern CGFloat const kStatusToolBarHeight;
extern CGFloat const kBottomMargin;


@interface JSStatusCell ()

// 原创微博视图
@property (nonatomic) JSStatusOriginalView *originalView;
// 转发微博
@property (nonatomic) JSStatusRetweetView *retweetView;
// 转发微博点击处理
@property (nonatomic) UIButton *retweetViewButton;
// 底部ToolBar视图
@property (nonatomic) JSStatusToolBarView *toolBarView;
// 记录ToolBar顶部约束
@property (nonatomic) MASConstraint *toolBarTopConstraint;

@end

@implementation JSStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

#pragma mark
#pragma mark -set up UI

- (void)prepareView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor js_colorWithHex:0xE8E8E8];
    self.contentView.backgroundColor = [UIColor js_colorWithHex:0xE8E8E8];
    
    [self.contentView addSubview:self.originalView];
    [self.contentView addSubview:self.retweetView];
    [self.contentView insertSubview:self.retweetViewButton belowSubview:self.retweetView];
    [self.contentView addSubview:self.toolBarView];
    
    [self.originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(kTopMargin);
        make.left.right.mas_equalTo(self.contentView);
        //make.height.mas_equalTo(kStatusOriginalViewHeight); 在JSStatusOriginalView中设置自身底边约束
    }];
    
    [self.retweetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.originalView.mas_bottom);
        //make.height.mas_equalTo(50); retweetView内部根据文本进行了高度适配
    }];
    
    [self.retweetViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.retweetView);
        make.height.mas_equalTo(self.retweetView);
    }];
    
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 根据是否有转发微博来设置底部ToolBar的顶部约束,默认先按照都有转发微博来进行设置,并在此记录顶部约束,根据传递数据是否有转发微博来更新约束
        self.toolBarTopConstraint = make.top.mas_equalTo(self.retweetView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kStatusToolBarHeight);
        // ios 10 & xcode 8 约束问题
        make.bottom.mas_equalTo(self.contentView).mas_offset(-kBottomMargin);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        // ios 10 & xcode 8 约束问题
        make.bottom.mas_equalTo(self);
        //make.bottom.mas_equalTo(self.toolBarView).mas_offset(kBottomMargin);
    }];
    
#pragma mark - URL处理
    __weak typeof(self) weakSelf = self;
    [self.originalView setUrlTextCompeletionHandler:^(NSString *text) {
        if (weakSelf.urlTextCompeletionHandler) {
            weakSelf.urlTextCompeletionHandler(text);
        }
    }];
    [self.retweetView setUrlTextCompeletionHandler:^(NSString *text) {
        if (weakSelf.RetweetUrlTextCompeletionHandler) {
            weakSelf.RetweetUrlTextCompeletionHandler(text);
        }
    }];
    
#pragma mark - 转发微博按钮点击处理
    [self.retweetViewButton addTarget:self action:@selector(clickRetweetViewButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击转发微博
- (void)clickRetweetViewButton:(UIButton *)sender {
    NSLog(@"%s",__func__);
}

#pragma mark
#pragma mark - transport data & update ToolBar top constraint
- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    // 原创微博视图传递数据
    self.originalView.statusData = statusData;
    
    // 卸载ToolBar的顶部约束
    [self.toolBarTopConstraint uninstall];
    
    if (statusData.retweeted_status) {
        
        // 转发微博传递数据 (需要先赋值,内部才能计算出正确的约束)
        self.retweetView.statusData = statusData.retweeted_status;
        
        // 显示转发微博
        self.retweetView.hidden = NO;
        
        // 有转发微博数据 (ToolBar顶部为RetweetView的底部)
        [self.toolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.toolBarTopConstraint = make.top.mas_equalTo(self.retweetView.mas_bottom);
        }];
        
    } else {
        // 没有转发微博数据 (ToolBar顶部为Original的底部) 隐藏转发微博
        self.retweetView.hidden = YES;
        
        // 更新约束
        [self.toolBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.toolBarTopConstraint = make.top.mas_equalTo(self.originalView.mas_bottom);
        }];
    }
    
    // 底部ToolBar传递数据
    self.toolBarView.statusData = statusData;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark 
#pragma mark - lazy

- (JSStatusOriginalView *)originalView {
    
    if (_originalView == nil) {
        _originalView = [[JSStatusOriginalView alloc] init];
    }
    return _originalView;
}

- (JSStatusRetweetView *)retweetView {
    
    if (_retweetView == nil) {
        _retweetView = [[JSStatusRetweetView alloc] init];
        _retweetView.userInteractionEnabled = YES;
    }
    return _retweetView;
}

- (UIButton *)retweetViewButton {
    
    if (_retweetViewButton == nil) {
        _retweetViewButton = [[UIButton alloc] init];
        [_retweetViewButton setTitle:@"" forState:UIControlStateNormal];
    }
    return _retweetViewButton;
}

- (JSStatusToolBarView *)toolBarView {
    
    if (_toolBarView == nil) {
        _toolBarView = [[JSStatusToolBarView alloc] init];
    }
    return _toolBarView;
}

@end
