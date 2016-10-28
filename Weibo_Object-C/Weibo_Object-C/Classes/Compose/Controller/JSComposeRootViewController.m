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
#import "JSComposeToolBar.h"


@interface JSComposeRootViewController () <UITextViewDelegate>

// TitleView视图
@property (nonatomic) UILabel *titleView;
// TextView
@property (nonatomic) JSComposeTextView *textView;
// 底部ToolBar
@property (nonatomic) JSComposeToolBar *composeToolBar;


@end

@implementation JSComposeRootViewController

//- (void)loadView {
//    
//    // 设置TextView
//    self.view = self.textView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareView];             // 设置视图
    [self prepareNavigationView];   // 设置导航栏视图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
#pragma mark - 设置视图

- (void)prepareView {
    
    // 设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置视图 ComposeTextView & ToolBar
    [self.view addSubview:self.textView];
    [self.view addSubview:self.composeToolBar];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.composeToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    // 发送通知
    //[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView userInfo:nil];
    
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
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

#pragma mark
#pragma mark - target

- (void)clickLeftBarButtonItem:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)clickRightBarButtonItem:(UIBarButtonItem *)sender {
    
    NSLog(@"%s",__func__);
}


#pragma mark
#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    // 有内容时发布按钮可以被点击
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
    // 设置占位文字的显示和隐藏
    self.textView.placeholderHidden = textView.hasText;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 辞去第一响应者
    [self.textView resignFirstResponder];
}



#pragma mark
#pragma mark - lazy

- (JSComposeTextView *)textView {
    
    if (_textView == nil) {
        _textView = [[JSComposeTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14];
        // 设置TextView垂直方向拖动
        _textView.alwaysBounceVertical = YES;
        _textView.delegate = self;
        _textView.placeholder = @"我的天空今天有点灰...";
    }
    return _textView;
}

- (UILabel *)titleView {
    
    if (_titleView == nil) {
        _titleView = [[UILabel alloc] init];
        NSString *userNickName = [JSUserAccountTool sharedManager].userAccountModel.screen_name;
        NSString *displayString = [NSString stringWithFormat:@"发微博\n%@",userNickName];
        NSRange range = [displayString rangeOfString:userNickName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, displayString.length - 1)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, displayString.length - 1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        _titleView.attributedText = attributedString;
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.numberOfLines = 0;
        [_titleView sizeToFit];
    }
    return _titleView;
}

- (JSComposeToolBar *)composeToolBar {
    
    if (_composeToolBar == nil) {
        _composeToolBar = [[JSComposeToolBar alloc] init];
        
        // ComposeToolBar按钮点击事件回调
        [_composeToolBar setCompletionHandler:^(JSComposeToolBarType toolBarButtonType) {
            
            switch (toolBarButtonType) {
                case JSComposeToolBarTypePicture:
                    NSLog(@"JSComposeToolBarTypePicture");
                    break;
                case JSComposeToolBarTypeMention:
                    NSLog(@"JSComposeToolBarTypeMention");
                    break;
                case JSComposeToolBarTypeTrend:
                    NSLog(@"JSComposeToolBarTypeTrend");
                    break;
                case JSComposeToolBarTypeEmoticon:
                    NSLog(@"JSComposeToolBarTypeEmoticon");
                    break;
                case JSComposeToolBarTypeAdd:
                    NSLog(@"JSComposeToolBarTypeAdd");
                    break;
                default:
                    break;
            }
            
        }];
    }
    return _composeToolBar;
}

@end
