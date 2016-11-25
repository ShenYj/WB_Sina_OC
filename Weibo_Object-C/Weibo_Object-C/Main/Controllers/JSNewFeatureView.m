//
//  JSNewFeatureView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSNewFeatureView.h"
#import "JSUserAccountTool.h"

@interface JSNewFeatureView () <UIScrollViewDelegate>

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.bottomScrolView];
    [self addSubview:self.pageControl];
    [self addSubview:self.entranceButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bottomScrolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(-100);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.entranceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.pageControl.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark 
#pragma mark - target
- (void)clickEntranceButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:[JSUserAccountTool sharedManager].kChangeRootViewControllerNotification object:nil userInfo:nil];
}

#pragma mark
#pragma mark -  UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPageIndex = (scrollView.contentOffset.x + SCREEN_WIDTH*0.5)/ SCREEN_WIDTH;
    self.pageControl.currentPage = currentPageIndex;
    
    currentPageIndex == 3 ? (self.entranceButton.hidden = NO) : (self.entranceButton.hidden = YES);
    
}


#pragma mark
#pragma mark - lazy

- (UIScrollView *)bottomScrolView {
    if (!_bottomScrolView) {
        _bottomScrolView = [[UIScrollView alloc] init];
        for (int i = 0; i < 4; i ++) {
            @autoreleasepool {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = [UIImage imageNamed:@"ad_background"];
                imageView.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                imageView.backgroundColor = [UIColor js_randomColor];
                [_bottomScrolView addSubview:imageView];
            }
        }
        _bottomScrolView.delegate = self;
        _bottomScrolView.contentSize = CGSizeMake(SCREEN_WIDTH *4, SCREEN_HEIGHT);
        _bottomScrolView.pagingEnabled = YES;
        _bottomScrolView.showsVerticalScrollIndicator = NO;
        _bottomScrolView.showsHorizontalScrollIndicator = NO;
        _bottomScrolView.bounces = NO;
    }
    return _bottomScrolView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl sizeToFit];
    }
    return _pageControl;
}

- (UIButton *)entranceButton {
    if (!_entranceButton) {
        _entranceButton = [[UIButton alloc] init];
        _entranceButton.hidden = YES;
        _entranceButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _entranceButton.frame = CGRectMake(0, 0, 240, 44);
        [_entranceButton setTitle:@"进入微博" forState:UIControlStateNormal];
        [_entranceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *image = [[UIImage imageNamed:@"tabbar_compose_button"] stretchableImageWithLeftCapWidth:120*0.5 topCapHeight:44*0.5];
        [_entranceButton setBackgroundImage:image forState:UIControlStateNormal];
        [_entranceButton addTarget:self action:@selector(clickEntranceButton:) forControlEvents:UIControlEventTouchUpInside];
        //[_entranceButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //[_entranceButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        
    }
    return _entranceButton;
}

@end
