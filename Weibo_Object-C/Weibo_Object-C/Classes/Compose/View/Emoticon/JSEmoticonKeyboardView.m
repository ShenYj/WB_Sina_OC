//
//  JSEmoticonKeyboardView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonKeyboardView.h"
#import "JSEmoticonPageView.h"
#import "JSEmoticonToolBar.h"
#import "JSEmoticonToolBarButton.h"
#import "JSEmoticonPageViewCell.h"
#import "JSEmoticonTool.h"

CGFloat const kEmoticonToolBarHeight = 37.f;             // 表情键盘底部Toolbar高度
CGFloat const kEmoticonPageViewHorizontalMargin = 5.f;   // 表情键盘左右两侧间距
CGFloat const kEmoticonPageViewBottomMargin = 20.f;      // 表情键盘表情区域底部间距


@interface JSEmoticonKeyboardView () <UICollectionViewDelegate>

// 表情键盘区
@property (nonatomic) JSEmoticonPageView *emoticonPageView;
// 表情键盘底部ToolBar
@property (nonatomic) JSEmoticonToolBar *emoticonToolBar;
// 记录滚动表情键盘时的索引
@property (assign,nonatomic) NSInteger currentIndex;
// PageControl
@property (nonatomic) UIPageControl *pageControl;


@end

@implementation JSEmoticonKeyboardView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

// 准备视图
- (void)prepareView {
    
    // 设置背景色
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
    
    // 添加子控件
    [self addSubview:self.emoticonPageView];
    [self addSubview:self.emoticonToolBar];
    
    [self addSubview:self.pageControl];
    // 添加约束
    [self.emoticonToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(kEmoticonToolBarHeight);
    }];
    
    [self.emoticonPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(kEmoticonPageViewHorizontalMargin);
        make.right.mas_equalTo(self).mas_offset(-kEmoticonPageViewHorizontalMargin);
        make.bottom.mas_equalTo(self.emoticonToolBar.mas_top).mas_equalTo(-kEmoticonPageViewBottomMargin);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emoticonPageView.mas_bottom);
        make.bottom.mas_equalTo(self.emoticonToolBar.mas_top);
        make.centerX.mas_equalTo(self);
    }];
    
    // 点击底部的ToolBar回调
    __weak typeof(self) weakSelf = self;
    [self.emoticonToolBar setClickCompeletionHandler:^(JSEmoticonToolBarButton *button) {
        
        // 获取点击button的枚举值
        NSInteger flag = button.toolBarButtonType - 1100;
        
        // 设置PageControl
        weakSelf.pageControl.numberOfPages = [JSEmoticonTool shared].allEmoticons[flag].count;
        weakSelf.pageControl.currentPage = 0;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:flag];
        [weakSelf.emoticonPageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }];
    
}

#pragma mark
#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取偏移量
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    // ContentOffset左边距离屏幕中心点距离
    CGFloat centerX = contentOffsetX +  SCREEN_WIDTH * 0.5;
    
    // 当屏幕显示2个Cell时,判断哪一个Cell占据屏幕的尺寸最大,来判断底部ToolBar显示选中按钮状态
    if (self.emoticonPageView.visibleCells.count > 1) {
        // 获取显示Cells
        NSArray *displayCells = (NSArray <JSEmoticonPageViewCell *>*)self.emoticonPageView.visibleCells;
        // 重新排序
        displayCells = [displayCells sortedArrayUsingComparator:^NSComparisonResult(JSEmoticonPageViewCell *obj1, JSEmoticonPageViewCell *obj2) {
            
            if (obj1.frame.origin.x > obj2.frame.origin.x) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }];
        // 获取前一个Cell和后一个Cell
        JSEmoticonPageViewCell *firstCell = displayCells.firstObject;
        JSEmoticonPageViewCell *lastCell = displayCells.lastObject;
        
        NSIndexPath *indexPath = nil;
        // 左侧Cell包含centerX点
        BOOL flag = CGRectContainsPoint(firstCell.frame, CGPointMake(centerX, 0));
        if (flag) {
            
            indexPath = [self.emoticonPageView indexPathForCell:firstCell];
        } else {
            
            indexPath = [self.emoticonPageView indexPathForCell:lastCell];
        }
        
        // 设置pageControl
        self.pageControl.numberOfPages = [JSEmoticonTool shared].allEmoticons[indexPath.section].count;
        self.pageControl.currentPage = indexPath.item;
        
        // 获取Section
        NSInteger section = indexPath.section;
        // 避免选中按钮多次调用,如果当前Section数相同,就直接返回
        if (self.currentIndex == section) {
            return;
        }
        self.currentIndex = section;
        
        // 设置选中按钮
        [self.emoticonToolBar setCurrentButtonIndex:self.currentIndex];
    }
    
}

#pragma mark
#pragma mark - lazy

- (JSEmoticonPageView *)emoticonPageView {
    
    if (_emoticonPageView == nil) {
        _emoticonPageView = [[JSEmoticonPageView alloc] init];
        _emoticonPageView.delegate = self;
    }
    return _emoticonPageView;
}


- (JSEmoticonToolBar *)emoticonToolBar {
    
    if (_emoticonToolBar == nil) {
        _emoticonToolBar = [[JSEmoticonToolBar alloc] init];
    }
    return _emoticonToolBar;
}

- (UIPageControl *)pageControl {
    
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = [JSEmoticonTool shared].allEmoticons[0].count;
        _pageControl.currentPage = 0;
        [_pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"currentPageImage"];
        //_pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        //_pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

@end
