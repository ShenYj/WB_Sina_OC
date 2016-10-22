//
//  JSStatusCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusCell.h"
#import "JSStatusOriginalView.h"
#import "JSStatusRetweetView.h"
#import "JSStatusToolBarView.h"

static CGFloat const kStatusToolBarHeight = 35.f;
static CGFloat const kBottomMargin = 5.f;
//static CGFloat const kStatusOriginalViewHeight = 50.f;


@interface JSStatusCell ()

// 原创微博视图
@property (nonatomic) JSStatusOriginalView *originalView;
// 转发微博
@property (nonatomic) JSStatusRetweetView *retweetView;
// 底部ToolBar视图
@property (nonatomic) JSStatusToolBarView *toolBarView;

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
    
    [self.contentView addSubview:self.originalView];
    [self.contentView addSubview:self.retweetView];
    [self.contentView addSubview:self.toolBarView];
    
    [self.originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        //make.height.mas_equalTo(kStatusOriginalViewHeight); 在JSStatusOriginalView中设置自身底边约束
    }];
    
    [self.retweetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.originalView.mas_bottom);
        //make.height.mas_equalTo(50); retweetView内部根据文本进行了高度适配
    }];
    
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.retweetView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kStatusToolBarHeight);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.toolBarView).mas_offset(kBottomMargin);
    }];
    
}

#pragma mark
#pragma mark - transport data
- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    // 原创微博视图传递数据
    self.originalView.statusData = statusData;
    // 转发微博传递数据
    self.retweetView.statusData = statusData;
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
    }
    return _retweetView;
}

- (JSStatusToolBarView *)toolBarView {
    
    if (_toolBarView == nil) {
        _toolBarView = [[JSStatusToolBarView alloc] init];
    }
    return _toolBarView;
}

@end
