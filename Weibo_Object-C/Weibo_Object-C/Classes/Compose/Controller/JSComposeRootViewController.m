//
//  JSComposeRootViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/27.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposeRootViewController.h"
#import "JSUserAccountTool.h"
#import "JSComposeTextView.h"

@interface JSComposeRootViewController ()

// TitleView视图
@property (nonatomic) UILabel *titleView;

@end

@implementation JSComposeRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareView];// 设置视图
    [self prepareNavigationView];// 设置导航栏视图
}

#pragma mark 
#pragma mark - 设置视图

- (void)prepareView {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark
#pragma mark - 设置导航栏视图
- (void)prepareNavigationView {
    
    // 中间TitleView
    self.navigationItem.titleView = self.titleView;
    // 左侧取消按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButtonItem:)];
    // 右侧发布按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
}

- (void)clickLeftBarButtonItem:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)clickRightBarButtonItem:(UIBarButtonItem *)sender {
    
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark - lazy

- (UILabel *)titleView {
    
    if (_titleView == nil) {
        _titleView = [[UILabel alloc] init];
        NSString *userNickName = [JSUserAccountTool sharedManager].userAccountModel.screen_name;
        NSString *displayString = [NSString stringWithFormat:@"发微博\n%@",userNickName];
        _titleView.text = displayString;
//        NSRange range = [displayString rangeOfString:userNickName];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayString];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
//        _titleView.attributedText = attributedString;
//        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.numberOfLines = 0;
        [_titleView sizeToFit];
    }
    return _titleView;
}

@end
