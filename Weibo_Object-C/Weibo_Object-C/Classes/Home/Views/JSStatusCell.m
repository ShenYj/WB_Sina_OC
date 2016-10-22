//
//  JSStatusCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusCell.h"
#import "JSStatusOriginalView.h"

#import "JSHomeStatusToolBarView.h"

static CGFloat const kStatusToolBarHeight = 35.f;
//static CGFloat const kStatusOriginalViewHeight = 50.f;


@interface JSStatusCell ()

// 原创微博视图
@property (nonatomic) JSStatusOriginalView *originalView;
// 底部ToolBar视图
@property (nonatomic) JSHomeStatusToolBarView *toolBarView;

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.originalView];
    [self.contentView addSubview:self.toolBarView];
    
    [self.originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        //make.height.mas_equalTo(kStatusOriginalViewHeight); 在JSStatusOriginalView中设置自身底边约束
    }];
    
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.originalView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kStatusToolBarHeight);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.toolBarView);
    }];
    
}

#pragma mark
#pragma mark - set up data
- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    
    self.originalView.statusData = statusData;
    
    
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

- (JSHomeStatusToolBarView *)toolBarView {
    
    if (_toolBarView == nil) {
        _toolBarView = [[JSHomeStatusToolBarView alloc] init];
    }
    return _toolBarView;
}

@end
