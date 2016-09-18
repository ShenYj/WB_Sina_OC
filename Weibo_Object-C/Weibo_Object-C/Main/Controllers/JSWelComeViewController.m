//
//  JSWelComeViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSWelComeViewController.h"
#import "JSUserAccountTool.h"


static CGFloat const kHeadIconImageViewBottomMargin = 100; // 用户头像距离底边的距离
static CGFloat const kHeadIconImageViewSize = 90;          // 用户头像尺寸
static CGFloat const kMargin = 10;                         // 用户头像与欢迎信息间距

@interface JSWelComeViewController ()


/**
 用户头像
 */
@property (nonatomic,strong) UIImageView *headIconImageView;
/**
 欢迎信息
 */
@property (nonatomic,strong) UILabel *messageLabel;


@end

@implementation JSWelComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareView];
}

- (void)prepareView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    [UIView animateWithDuration:2 delay:0.8 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.headIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).mas_offset( -SCREEN_HEIGHT * 0.7);
        }];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.messageLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            // 发布通知: 切换控制器
            [[NSNotificationCenter defaultCenter] postNotificationName:[JSUserAccountTool sharedManager].kChangeRootViewControllerNotification object:nil userInfo:nil];
        }];
        
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - lazy

- (UIImageView *)headIconImageView {
    
    if (_headIconImageView == nil) {
        _headIconImageView = [[UIImageView alloc] init];
        [_headIconImageView yy_setImageWithURL:[NSURL URLWithString:[JSUserAccountTool sharedManager].userAccountModel.avatar_large] options:YYWebImageOptionShowNetworkActivity];
    }
    return _headIconImageView;
}

- (UILabel *)messageLabel {
    
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"欢迎回来";
        _messageLabel.alpha = 0.01;
        _messageLabel.font = [UIFont systemFontOfSize:18];
        _messageLabel.textColor = THEME_COLOR;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

@end
