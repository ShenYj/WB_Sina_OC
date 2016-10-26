//
//  JSRefresh.m
//  JSRefresh
//
//  Created by ShenYj on 2016/10/25.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

/**
     自定义下拉刷新控件:
        控件Y轴 == -控件高度
     自定义下拉刷新控件状态:
        1.如果正在拖动TableView && 没有松手
            -- 正常   contentOffset.y > -114(tableView默认偏移64 + 下拉刷新控件自身高度)
            -- 下拉中 contentOffset.y <= -114
        2.如果停止拖动 && 松手 && 状态下拉中
            -- 刷新中
     
 */

#import "JSRefresh.h"

// 自定义下拉刷新控件的状态
typedef NS_ENUM(NSUInteger, JSRefreshCurrentStatus) {
    JSRefreshCurrentStatusIsNormal,         // 正常状态
    JSRefreshCurrentStatusIsPulling,        // 下拉中
    JSRefreshCurrentStatusIsRefreshing,     // 正在刷新
};

static CGFloat const kRefreshHeigh = 50.f;          // 下拉刷新控件的高度
static CGFloat const kStatusLabelFontSize = 15.f;   // 下拉刷新控件的状态文字大小
static NSString * const kKeyPath = @"contentOffset";


@interface JSRefresh ()


// 自定义下拉刷新控件状态
@property (assign,nonatomic) JSRefreshCurrentStatus refreshCurrentStatus;

// 状态展示Label
@property (nonatomic) UILabel *statusLabel;

// 被观察对象
@property (weak,nonatomic) UIScrollView *superScrollView;

// 记录状态(上一个状态是否属于正在刷新中)
@property (assign,nonatomic) BOOL isLastStatusRefreshing;


@end

@implementation JSRefresh

// 构造函数
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:CGRectMake(0, -kRefreshHeigh, [UIScreen mainScreen].bounds.size.width, kRefreshHeigh)];
    if (self) {
        
        [self prepareRefreshView];
    }
    return self;
}

- (void)endRefresh {
    
    self.refreshCurrentStatus = JSRefreshCurrentStatusIsNormal;
}

// 设置视图
- (void)prepareRefreshView {
    
    // 设置初始状态 --> 正常状态
    self.refreshCurrentStatus = JSRefreshCurrentStatusIsNormal;
    // 设置背景色
    self.backgroundColor = [UIColor purpleColor];
    
    // 添加子视图 (状态)
    [self addSubview:self.statusLabel];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
}

// 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLayoutConstraint *statusLabelTop = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:statusLabelTop];
    
    NSLayoutConstraint *statusLabelBottom = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self addConstraint:statusLabelBottom];
    
    NSLayoutConstraint *statusLabelRight = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraint:statusLabelRight];
    
    NSLayoutConstraint *statusLabelLeft = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self addConstraint:statusLabelLeft];
    
}

// 当前控件将要添加到父控件中时调用
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    self.superScrollView = (UIScrollView *)newSuperview;
    
    // 添加观察者
    [self.superScrollView addObserver:self forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    // 获取父视图滚动的偏移量
    CGFloat contentOffsetY = self.superScrollView.contentOffset.y;
    
    // 偏移量的临界值 -(父视图顶部内间距 + 自定义下拉刷新控件的高度)
    CGFloat contentOffsetYCriticalValue = -(self.superScrollView.contentInset.top + kRefreshHeigh);
    
    if (self.superScrollView.isDragging) {
        // 拖动状态
        if (contentOffsetY > contentOffsetYCriticalValue && self.refreshCurrentStatus == JSRefreshCurrentStatusIsPulling ) {
            
            // 防止重复进入,当偏移量大于 -(自身高度+TableView偏移量)时,并且当前状态为下拉中状态时,将状态修改回正常
            self.refreshCurrentStatus = JSRefreshCurrentStatusIsNormal;
            //NSLog(@"正常");
            
        } else if (contentOffsetY <= contentOffsetYCriticalValue && self.refreshCurrentStatus == JSRefreshCurrentStatusIsNormal ) {
            
            // 同样防止重复进入,当偏移量小于 -(自身高度+TableView偏移量)时,并且当前状态为正常状态时,将状态修改为下拉中
            self.refreshCurrentStatus = JSRefreshCurrentStatusIsPulling;
            //NSLog(@"下拉中");
        }
        
    } else {
        // 停止拖动&&松手
        if (self.refreshCurrentStatus == JSRefreshCurrentStatusIsPulling) { // 当前状态为下拉中时
            
            self.refreshCurrentStatus = JSRefreshCurrentStatusIsRefreshing;
            //NSLog(@"刷新中");
            
        }
        
    }
    
}

// 重写refreshCurrentStatus setter方法
- (void)setRefreshCurrentStatus:(JSRefreshCurrentStatus)refreshCurrentStatus {
    
    if (_refreshCurrentStatus == JSRefreshCurrentStatusIsRefreshing) {
        self.isLastStatusRefreshing = YES;
    } else {
        self.isLastStatusRefreshing = NO;
    }
    
    _refreshCurrentStatus = refreshCurrentStatus;
    
    switch (refreshCurrentStatus) {
            
        case JSRefreshCurrentStatusIsNormal:
            self.statusLabel.text = @"正常";
            {   // 恢复正常状态后,调整回默认的顶部内边距
                if (self.isLastStatusRefreshing) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        [self.superScrollView setContentInset:UIEdgeInsetsMake(self.superScrollView.contentInset.top - kRefreshHeigh, 0, 0, 0)];
                    }];
                }
                
            };
            break;
            
        case JSRefreshCurrentStatusIsPulling:
            self.statusLabel.text = @"下拉中";
            break;
            
        case JSRefreshCurrentStatusIsRefreshing:
            self.statusLabel.text = @"刷新中";
            {   // 刷新中状态时,通过手动设置顶部内边距,让自定义刷新控件保留显示
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [self.superScrollView setContentInset:UIEdgeInsetsMake(self.superScrollView.contentInset.top + kRefreshHeigh, 0, 0, 0)];
                    
                } completion:^(BOOL finished) {
                    
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                    
                }];
            };
            break;
            
        default:
            break;
    }
    
    
}


- (void)dealloc {
    // 移除观察者
    [self.superScrollView removeObserver:self forKeyPath:kKeyPath context:nil];
}


#pragma mark 
#pragma mark - lazy

- (UILabel *)statusLabel {
    
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:kStatusLabelFontSize];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.text = @"正常";
    }
    return _statusLabel;
}

@end
