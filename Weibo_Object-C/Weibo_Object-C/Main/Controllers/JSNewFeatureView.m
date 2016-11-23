//
//  JSNewFeatureView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSNewFeatureView.h"

@interface JSNewFeatureView ()

@property (nonatomic,strong) UIScrollView *bottomScrolView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *entranceButton;

@end

@implementation JSNewFeatureView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self prepareNewFeatureView];
    }
    return self;
}

- (void)prepareNewFeatureView {
    self.backgroundColor = [UIColor js_randomColor];
    
    
}


#pragma mark
#pragma mark - lazy

- (UIScrollView *)bottomScrolView {
    if (!_bottomScrolView) {
        _bottomScrolView = [[UIScrollView alloc] init];
    }
    return _bottomScrolView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
        _pageControl.tintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}

- (UIButton *)entranceButton {
    if (!_entranceButton) {
        [_entranceButton setTitle:@"进入微博" forState:UIControlStateNormal];
        _entranceButton = [[UIButton alloc] init];
        [_entranceButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_entranceButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
    return _entranceButton;
}

@end
