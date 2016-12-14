//
//  JSComposeView.m
//  ComposeView
//
//  Created by ShenYj on 2016/12/8.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

#import "JSComposeView.h"
#import "JSComposeButton.h"
#import "Masonry.h"
#import "Pop.h"

/** 菜单区按钮的宽高参数 */
static CGFloat const kComposeButtonWH = 100.f;
/** 惨淡去按钮垂直间距 */
static CGFloat const kComposeButtonVerticalMargin = 24.f;


@interface JSComposeView ()

/** 视觉视效 */
@property (nonatomic) UIVisualEffectView *visualEffectView;
/** slogan */
@property (nonatomic) UIImageView *compose_slogan_IV;
/** 中间的按钮区ScrollView */
@property (nonatomic) UIScrollView *centerArea_ScrollView;
/** 底部View */
@property (nonatomic) UIView *bottom_View;

/** 记录完成回调Block*/
@property (nonatomic,copy) void(^compeletionHandler)();
/** 按钮数组数据 */
@property (nonatomic) NSArray *buttonDatas;

@end

@implementation JSComposeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)prepareView {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.visualEffectView];
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self addSubview:self.bottom_View];
    [self addSubview:self.compose_slogan_IV];
    [self addSubview:self.centerArea_ScrollView];
    
    // 添加菜单区视图
    for (int i = 0; i < 2; i ++) {
        UIView *containterView = [[UIView alloc] init];
        containterView.backgroundColor = [UIColor clearColor];
        [self.centerArea_ScrollView addSubview:containterView];
        [self addButtonsWithIndex:i*6 withView:containterView];
    }
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.compose_slogan_IV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).mas_offset(100);
    }];
    [self.bottom_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.centerArea_ScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(224);
        make.bottom.mas_equalTo(self.bottom_View.mas_top).mas_offset(-60);
    }];
    
    CGFloat kComposeButtonHorizontalMargin = ([UIScreen mainScreen].bounds.size.width - kComposeButtonWH * 3) / (3 + 1);
    for (int i = 0; i < self.centerArea_ScrollView.subviews.count; i ++) {
        
        UIView *containterView = self.centerArea_ScrollView.subviews[i];
        containterView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 224);
        [containterView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger row = idx / 3;
            NSInteger col = idx % 3;
            CGFloat coordinateX = kComposeButtonHorizontalMargin + (kComposeButtonHorizontalMargin + kComposeButtonWH) * col;
            CGFloat coordinateY = (kComposeButtonVerticalMargin + kComposeButtonWH) * row;
            obj.frame = CGRectMake(coordinateX, coordinateY, kComposeButtonWH, kComposeButtonWH);
        }];
    }
    

}



#pragma mark
#pragma mark - target

- (void)clickBackButton:(UIButton *)sender {
    [self.centerArea_ScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.bottom_View.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.alpha = 0.01;
        }
        [UIView animateWithDuration:0.25 animations:^{
            
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.centerX.mas_equalTo(self.bottom_View);
            }];
            [self layoutIfNeeded];
        }];
    }];
}

- (void)clickCloseButton:(UIButton *)sender {
    [self hiddenButtons];
}

- (void)clickComposeButton:(JSComposeButton *)composeButton {
    
    NSInteger currentContainterViewIndex = self.centerArea_ScrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    UIView *currentContainterView = self.centerArea_ScrollView.subviews[currentContainterViewIndex];
    
    [currentContainterView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 缩放
        POPBasicAnimation *zoomAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        zoomAnimation.duration = 0.25;
        CGFloat scale = composeButton == obj ? 2 : 0.5;
        zoomAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(scale, scale)];
        [obj pop_addAnimation:zoomAnimation forKey:nil];
        // 透明度
        POPBasicAnimation *alphaANimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        alphaANimation.fromValue = @1;
        alphaANimation.toValue = @0;
        alphaANimation.duration = 0.25;
        [obj pop_addAnimation:alphaANimation forKey:nil];
        
        if (idx == 0) {
            // 不需要每个按钮的动画都监听,因为同时进行,所以随便监听一个即可
            __weak typeof(self) weakSelf = self;
            [alphaANimation setCompletionBlock:^(POPAnimation *animation, BOOL _) {
                [weakSelf removeFromSuperview];
                weakSelf.compeletionHandler(composeButton.clsName);
                
            }];
        }
        
    }];
    
}

- (void)clickMore {
    
    [self.centerArea_ScrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:YES];
    
    [self.bottom_View.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat offsetX = idx == 0 ?  -1*40 : 40;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            obj.alpha = 1;
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.bottom_View).mas_offset(offsetX);
            }];
            [self layoutIfNeeded];
        }];
    }];
}

// 展示视图
- (void)showComposeViewWithCompeletionHandler:(void (^)(NSString *clsName))compeletionHandler {
    // 记录完成回调
    self.compeletionHandler = compeletionHandler;
    // 添加到视图
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    // 开始动画
    [self showCurrentView];
    // 添加按钮的动画
    [self showButtons];
    
}
/** 展示视图时的动画 */
- (void)showCurrentView {
    
    POPBasicAnimation *basicAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    basicAlphaAnimation.fromValue = @0;
    basicAlphaAnimation.toValue = @1;
    basicAlphaAnimation.duration = 0.25;
    [self pop_addAnimation:basicAlphaAnimation forKey:nil];
}
/** 弹力显示所有按钮的动画 */
- (void)showButtons {
    
    UIView *firstContainterView = self.centerArea_ScrollView.subviews.firstObject;
    CGFloat kComposeButtonHorizontalMargin = ([UIScreen mainScreen].bounds.size.width - kComposeButtonWH * 3) / (3 + 1);
    
    [firstContainterView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 动画
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        
        NSInteger row = idx / 3;
        NSInteger col = idx % 3;
        CGFloat coordinateX = kComposeButtonHorizontalMargin + (kComposeButtonHorizontalMargin + kComposeButtonWH) * col;
        CGFloat coordinateY = (kComposeButtonVerticalMargin + kComposeButtonWH) * row;
        obj.frame = CGRectMake(coordinateX, coordinateY, kComposeButtonWH, kComposeButtonWH);

        sprintAnimation.fromValue = @(obj.center.y + 400);
        sprintAnimation.toValue = @(obj.center.y);
        sprintAnimation.springBounciness = 8;
        sprintAnimation.springSpeed = 10;
        sprintAnimation.beginTime = CACurrentMediaTime() + idx * 0.025;
        
        [obj.layer pop_addAnimation:sprintAnimation forKey:nil];
    }];
    
}
/** 关闭视图隐藏按钮的动画 */
- (void)hiddenButtons {
    
    NSInteger currentDispagePage = self.centerArea_ScrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    UIView *currentDisplayContainterView = self.centerArea_ScrollView.subviews[currentDispagePage];
    
    [currentDisplayContainterView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        POPSpringAnimation *hiddenAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        hiddenAnimation.fromValue = @(obj.center.y);
        hiddenAnimation.toValue = @(obj.center.y + 400);
        hiddenAnimation.beginTime = CACurrentMediaTime() + (currentDisplayContainterView.subviews.count - idx) * 0.025;
        hiddenAnimation.springBounciness = 8;
        hiddenAnimation.springSpeed = 10;
        
        [obj.layer pop_addAnimation:hiddenAnimation forKey:nil];
        
        if (idx == 0) {
            [hiddenAnimation setCompletionBlock:^(POPAnimation *animation, BOOL _) {
                [self hiddenCurrentView];
            }];
        }
        
    }];
}

/** 隐藏自身视图 */
- (void)hiddenCurrentView {
    
    POPBasicAnimation *hiddenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    hiddenAnimation.fromValue = @1;
    hiddenAnimation.toValue = @0;
    hiddenAnimation.duration = 0.25;
    
    [self pop_addAnimation:hiddenAnimation forKey:nil];
    
    [hiddenAnimation setCompletionBlock:^(POPAnimation *animation, BOOL _ ) {
        [self removeFromSuperview];
    }];
    
}

/** 中间ScrollView的容器视图添加按钮方法 */
- (void)addButtonsWithIndex:(int)index withView:(UIView *)view {
    int count = 6;
    for (int i = index; i < (index + count); i++) {
        if ( i >= self.buttonDatas.count) {
            break;
        }
        
        NSDictionary *dict = self.buttonDatas[i];
        JSComposeButton *button = [[JSComposeButton alloc] initWithTitle:dict[@"title"] imageName:dict[@"imageName"]];
        
        if (dict[@"clsName"]) {
            button.clsName = dict[@"clsName"];
        }
        
        if (dict[@"actionName"]) {
            NSString *actionName = dict[@"actionName"];
            [button addTarget:self action:NSSelectorFromString(actionName) forControlEvents:UIControlEventTouchUpInside];
        } else {
            
            [button addTarget:self action:@selector(clickComposeButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:button];
        
    }
    
}

#pragma mark
#pragma mark - lazy

- (UIVisualEffectView *)visualEffectView {
    if (!_visualEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _visualEffectView;
}

- (UIImageView *)compose_slogan_IV {
    if (!_compose_slogan_IV) {
        _compose_slogan_IV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_slogan"]];
    }
    return _compose_slogan_IV;
}

- (UIScrollView *)centerArea_ScrollView {
    if (!_centerArea_ScrollView) {
        _centerArea_ScrollView = [[UIScrollView alloc] init];
        _centerArea_ScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2, 224);
        _centerArea_ScrollView.backgroundColor = [UIColor clearColor];
        _centerArea_ScrollView.bounces = NO;
        _centerArea_ScrollView.pagingEnabled = YES;
        _centerArea_ScrollView.showsHorizontalScrollIndicator = NO;
        _centerArea_ScrollView.showsVerticalScrollIndicator = NO;
        _centerArea_ScrollView.scrollEnabled = NO;
        _centerArea_ScrollView.clipsToBounds = NO;
    }
    return _centerArea_ScrollView;
}

- (UIView *)bottom_View {
    if (!_bottom_View) {
        _bottom_View = [[UIView alloc] init];
        _bottom_View.backgroundColor = [UIColor clearColor];
        UIButton *backButton = [[UIButton alloc] init];
        UIButton *closeButton = [[UIButton alloc] init];
        backButton.alpha = 0.01;
        [backButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_background_icon_return"] forState:UIControlStateNormal];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close"] forState:UIControlStateNormal];
        [_bottom_View addSubview:backButton];
        [_bottom_View addSubview:closeButton];
        [backButton sizeToFit];
        [closeButton sizeToFit];
        [backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_bottom_View);
        }];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_bottom_View);
        }];
    }
    return _bottom_View;
}

- (NSArray *)buttonDatas {
    if (!_buttonDatas) {
        _buttonDatas =  @[
                          @{@"imageName": @"tabbar_compose_idea", @"title": @"文字", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_photo", @"title": @"照片/视频", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_weibo", @"title": @"长微博", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_lbs", @"title": @"签到", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_review", @"title": @"点评", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_more", @"title": @"更多", @"actionName": @"clickMore", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_friend", @"title": @"好友圈", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_wbcamera", @"title": @"微博相机", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_music", @"title": @"音乐", @"clsName": @"JSTextViewController"},
                          @{@"imageName": @"tabbar_compose_shooting", @"title": @"拍摄", @"clsName": @"JSTextViewController"}
                          ];

    }
    return _buttonDatas;
}

@end
