//
//  JSComposeRootViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/27.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposeRootViewController.h"
#import "JSNetworkTool.h"
#import "JSUserAccountTool.h"
#import "JSComposeTextView.h"
#import "JSComposeToolBar.h"
#import "JSComposePictureView.h"

CGFloat const kPictureMarginHorizontal = 10.f; // 配图视图左右的间距
static CGFloat const kPictureMarginVertical = 100.f;


@interface JSComposeRootViewController () <UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

// TitleView视图
@property (nonatomic) UILabel *titleView;
// TextView
@property (nonatomic) JSComposeTextView *textView;
// 底部ToolBar
@property (nonatomic) JSComposeToolBar *composeToolBar;
// 配图视图
@property (nonatomic) JSComposePictureView *pictureView;

@end

@implementation JSComposeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareView];             // 设置视图
    [self prepareNavigationView];   // 设置导航栏视图
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    // 设置视图 ComposeTextView & ToolBar & 配图视图
    [self.view addSubview:self.textView];
    [self.view addSubview:self.composeToolBar];
    [self.textView addSubview:self.pictureView];
    
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView).mas_offset(kPictureMarginVertical);
        make.left.mas_equalTo(self.textView).mas_offset(kPictureMarginHorizontal);
        make.width.mas_equalTo(SCREEN_WIDTH - 2*kPictureMarginHorizontal);
        make.height.mas_equalTo(SCREEN_WIDTH - 2*kPictureMarginHorizontal);
    }];
    
    [self.composeToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    // 通过系统通知监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 发送通知
    //[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView userInfo:nil];
    
}

// 键盘Frame将要改变时接收到通知调用的方法
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    //NSLog(@"%@",notification.userInfo[UIKeyboardFrameEndUserInfoKey]);
    // 获取到键盘的Rect
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 更新ToolBar的底边约束
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.composeToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(keyboardRect.origin.y - SCREEN_HEIGHT);
        }];
        
        [self.view layoutIfNeeded];
    }];
    
}

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

// dismiss控制器
- (void)clickLeftBarButtonItem:(UIBarButtonItem *)sender {
    // 取消第一响应者
    [self.textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

// 发布微博
- (void)clickRightBarButtonItem:(UIBarButtonItem *)sender {
    
    // 发布微博
    [[JSNetworkTool sharedNetworkTool] composeStatus:self.textView.text withFinishedBlock:^(id obj, NSError *error) {
        
        if (error) {
            NSLog(@"错误信息:%@",error);
        }
    }];
    
    // 辞去第一响应者&dismiss控制器
    [self clickLeftBarButtonItem:nil];
    
}

#pragma mark - ToolBar区 按钮点击事件
- (void)clickComposeToolBarAreaButton:(JSComposeToolBarType)toolBarType {
    
    switch (toolBarType) {
        case JSComposeToolBarTypePicture:       // 选择图片
            [self selectPicture];
            break;
        case JSComposeToolBarTypeMention:       //
            NSLog(@"JSComposeToolBarTypeMention");
            break;
        case JSComposeToolBarTypeTrend:         //
            NSLog(@"JSComposeToolBarTypeTrend");
            break;
        case JSComposeToolBarTypeEmoticon:       // 表情键盘
            [self Selectemoticon];
            break;
        case JSComposeToolBarTypeAdd:            //
            NSLog(@"JSComposeToolBarTypeAdd");
            break;
        default:
            break;
    }
    
}

// 选择照片
- (void)selectPicture {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

// 表情键盘
- (void)Selectemoticon {
    
    
}

#pragma mark
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    // 添加图片
    [self.pictureView insertImage:image];
    // 释放控制器
    [self dismissViewControllerAnimated:YES completion:nil];
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
        __weak typeof(self) weakSelf = self;
        // ComposeToolBar按钮点击事件回调
        [_composeToolBar setCompletionHandler:^(JSComposeToolBarType toolBarButtonType) {
            // 调用内部的按钮点击事件方法
            [weakSelf clickComposeToolBarAreaButton:JSComposeToolBarTypePicture];
            
        }];
    }
    return _composeToolBar;
}

- (JSComposePictureView *)pictureView {
    
    if (_pictureView == nil) {
        _pictureView = [[JSComposePictureView alloc] init];
    }
    return _pictureView;
}

@end
