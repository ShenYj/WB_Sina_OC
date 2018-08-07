//
//  JSWelComeViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSWelComeViewController.h"
#import "JSUserAccountTool.h"
#import "JSNewFeatureView.h"

static CGFloat const kHeadIconImageViewBottomMargin = 100.f; // 用户头像距离底边的距离
static CGFloat const kHeadIconImageViewSize = 100.f;         // 用户头像尺寸
static CGFloat const kMargin = 10.f;                         // 用户头像与欢迎信息间距


@interface JSWelComeViewController ()

/**
 用户头像
 */
@property (nonatomic,strong) UIImageView *headIconImageView;
/**
 欢迎信息
 */
@property (nonatomic,strong) UILabel *messageLabel;
/**
 新特性视图
 */
@property (nonatomic,strong) JSNewFeatureView *newFeatureView;

@end

@implementation JSWelComeViewController


- (BOOL)isNewVersion {
    
    // 获取本地保存的版本
    NSString *localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"localVersion"];
    // 从Infoplist中获取当前版本
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    if ([localVersion isEqualToString:currentVersion]) {
        return YES;
    }
    // 保存当前版本
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"localVersion"];
    return NO;
    
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    // 判断当前软件版本,如果是最新版本,就加载欢迎视图,如果与上一次记录的版本不一致,则加载新特性视图
    [self isNewVersion] ? ([self prepareView]) : ([self prepareNewVersionView]);
}

- (void)prepareNewVersionView {
    [self.view addSubview:self.newFeatureView];
    [self.newFeatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)prepareView {
    
    [[ALBBMANAnalytics getInstance] updateUserAccount:[JSUserAccountTool sharedManager].getUerAccount.screen_name
                                               userid:[JSUserAccountTool sharedManager].getUerAccount.uid];
    
    [self.view addSubview:self.headIconImageView];
    [self.view addSubview:self.messageLabel];
    
    [self.headIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-kHeadIconImageViewBottomMargin);
        make.size.mas_equalTo(CGSizeMake(kHeadIconImageViewSize, kHeadIconImageViewSize));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headIconImageView.mas_bottom).mas_offset(kMargin);
        make.centerX.mas_equalTo(self.view);
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.headIconImageView.superview && self.messageLabel.superview ) {
        
        [UIView animateWithDuration:2 delay:0.8 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            [self.headIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view).mas_offset( -SCREEN_HEIGHT * 0.7);
            }];
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.messageLabel.alpha = 1;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 发布通知: 切换控制器
                    [[NSNotificationCenter defaultCenter] postNotificationName:[JSUserAccountTool sharedManager].kChangeRootViewControllerNotification object:nil userInfo:nil];
                });
            }];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - lazy

- (UIImageView *)headIconImageView {
    if (_headIconImageView == nil) {
        _headIconImageView            = [[UIImageView alloc] init];
        __weak UIImageView *imageView = _headIconImageView;
        [_headIconImageView js_imageUrlString:[JSUserAccountTool sharedManager].userAccountModel.avatar_large WithSize:CGSizeMake(kHeadIconImageViewSize, kHeadIconImageViewSize) fillClolor:[UIColor whiteColor] completion:^(UIImage *img) {
            imageView.image = img;
        }];
    }
    return _headIconImageView;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel       = [[UILabel alloc] init];
        _messageLabel.text  = @"欢迎回来";
        _messageLabel.alpha = 0.01;
        _messageLabel.font  = [UIFont systemFontOfSize:18];
        _messageLabel.textColor     = THEME_COLOR;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (JSNewFeatureView *)newFeatureView {
    if (_newFeatureView == nil) {
        _newFeatureView = [[JSNewFeatureView alloc] init];
    }
    return _newFeatureView;
}

@end
