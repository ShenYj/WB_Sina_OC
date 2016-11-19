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
#import "JSEmoticonKeyboardView.h"
#import "JSEmoticonModel.h"
#import "JSEmoticonTool.h"
#import "JSEmoticonTextAttachment.h"

CGFloat const kPictureMarginHorizontal = 10.f; // 配图视图左右的间距
CGFloat const kKeyboardViewHeigth = 216.f;     // 自定义表情键盘高度
static CGFloat const kPictureMarginVertical = 100.f;
extern CGFloat itemSize;

@interface JSComposeRootViewController () <UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

// TitleView视图
@property (nonatomic) UILabel *titleView;
// TextView
@property (nonatomic) JSComposeTextView *textView;
// 底部ToolBar
@property (nonatomic) JSComposeToolBar *composeToolBar;
// 配图视图
@property (nonatomic) JSComposePictureView *pictureView;
// 自定义表情键盘
@property (nonatomic) JSEmoticonKeyboardView *keyboardView;


@end

@implementation JSComposeRootViewController


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    
    NSLog(@"%ld",(long)previousTraitCollection.userInterfaceIdiom);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUpUI {
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
    //[self.view insertSubview:self.textView belowSubview:self.js_NavigationBar];
    [self.view addSubview:self.composeToolBar];
    [self.textView addSubview:self.pictureView];
    
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(64);
        make.left.right.bottom.mas_equalTo(self.view);
        //make.edges.mas_equalTo(self.view);
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
    // 注册删除按钮通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEmoticonButtonNotification:) name:@"deleteEmoticonButtonNotification" object:nil];
    // 注册表情按钮通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickEmoticonButtonNotification:) name:@"clickEmoticonButtonNotification" object:nil];
    
    __weak typeof(self) weakSelf = self;
    [self.composeToolBar setCompletionHandler:^(JSComposeToolBarButton *toolBarButton) {
        // 调用内部的按钮点击事件方法
        [weakSelf clickComposeToolBarAreaButton:toolBarButton];
    }];
    
    // 添加图片
    [self.pictureView setInserImageHandler:^{
        [weakSelf selectPicture];
    }];
    
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
    self.js_navigationItem.titleView = self.titleView;
    // 左侧取消按钮
    self.js_navigationItem.leftBarButtonItem = [[JSBaseNavBarButtonItem alloc] initWithTitle:@"取消"
                                                                                    withFont:16
                                                                                  withTarget:self
                                                                                  withAction:@selector(clickLeftBarButtonItem:)
                                                ];
    // 右侧发布按钮
    self.js_navigationItem.rightBarButtonItem = [[JSBaseNavBarButtonItem alloc] initWithTitle:@"发布"
                                                                                     withFont:16
                                                                                   withTarget:self
                                                                                   withAction:@selector(clickRightBarButtonItem:)
                                                 ];
    
    self.js_navigationItem.rightBarButtonItem.enabled = NO;
    
}

#pragma mark
#pragma mark - 导航栏按钮点击事件

// dismiss控制器
- (void)clickLeftBarButtonItem:(JSBaseNavBarButtonItem *)sender {
    // 取消第一响应者
    [self.textView resignFirstResponder];
    // 释放控制器
    [self dismissViewControllerAnimated:YES completion:nil];

}

// 发布微博
- (void)clickRightBarButtonItem:(JSBaseNavBarButtonItem *)sender {
    
    // 拼接表情+文本的可变字符串
    NSMutableString *composeText = [[NSMutableString alloc] init];
    
    // 遍历TextView的富文本
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        JSEmoticonTextAttachment *emoticonTextAttachment = (JSEmoticonTextAttachment *)attrs[@"NSAttachment"];
        if (emoticonTextAttachment) {
            // 文本附件
            [composeText appendString:emoticonTextAttachment.emoticonModel.chs];
        } else {
            // 纯文本
            [composeText appendString:[self.textView.attributedText.string substringWithRange:range]];
        }
        
    }];
    
    if (!(self.pictureView.images.count > 0)) {
        // 发布文字微博
        [[JSNetworkTool sharedNetworkTool] composeStatus:composeText.copy withFinishedBlock:^(id obj, NSError *error) {
            
            if (error) {
                NSLog(@"错误信息:%@",error);
            }
        }];
    } else {
        // 发布文字&图片微博
        NSDictionary *datas = @{
                                @"status": composeText.copy,
                                @"pics": self.pictureView.images
                                };
        [[JSNetworkTool sharedNetworkTool] composeStatusWithPictures:datas withFinishedBlock:^(id obj, NSError *error) {
            
            if (error) {
                NSLog(@"发布失败:%@",error);
            }
        }];
        
    }
    
    // 辞去第一响应者&dismiss控制器
    [self clickLeftBarButtonItem:nil];
    
}

#pragma mark - ToolBar区 按钮点击事件
- (void)clickComposeToolBarAreaButton:(JSComposeToolBarButton *)toolBarButton {
    
    JSComposeToolBarType toolBarType = toolBarButton.toolBarButtonType;
    switch (toolBarType) {
        case JSComposeToolBarTypePicture:        // 选择图片
            [self selectPicture];
            break;
        case JSComposeToolBarTypeMention:        //
            NSLog(@"JSComposeToolBarTypeMention");
            break;
        case JSComposeToolBarTypeTrend:          //
            NSLog(@"JSComposeToolBarTypeTrend");
            break;
        case JSComposeToolBarTypeEmoticon:       // 表情键盘
            [self Selectemoticon:toolBarButton];
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

// 图片压缩处理
- (UIImage *)scaleImage:(UIImage *)originalImage withExpectWidth:(CGFloat )expectWidth {
    
    // 原始图片的Size
    CGSize imageOriginalSize = originalImage.size;
    
    if (expectWidth >= originalImage.size.width) {
        // 如果传入图片的宽度已经小于等于期望压缩后的宽度,原图返回
        return originalImage;
    }
    
    // 计算比例
    CGFloat scale = expectWidth / imageOriginalSize.width;
    CGRect rect = CGRectMake(0, 0, expectWidth, imageOriginalSize.height * scale);
    // 绘图
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    // 将图片绘制到图形上下文中
    [originalImage drawInRect:rect];
    // 重新获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

// 切换键盘
- (void)Selectemoticon:(JSComposeToolBarButton *)toolBarButton {
    
    if (self.textView.inputView == nil) {
        // 自定义表情键盘
        self.textView.inputView = self.keyboardView;
        self.composeToolBar.emoticon = YES;
    } else {
        
        self.textView.inputView = nil;
        self.composeToolBar.emoticon = NO;
    }
    // 刷新InputView
    [self.textView reloadInputViews];
    // 成为第一响应者 (解决首次点击没有反应)
    [self.textView becomeFirstResponder];
}


// 删除按钮通知的实现
- (void)deleteEmoticonButtonNotification:(NSNotification *)notification {
    
    [self.textView deleteBackward];
}

- (void)clickEmoticonButtonNotification:(NSNotification *)notification {
    
    JSEmoticonModel *emoticonModel = (JSEmoticonModel *)notification.object;
    
    if (emoticonModel.isEmoji) {
        // emoji表情
        [self.textView insertText:[emoticonModel.code emoji]];
        
        
    } else {
        // 图片表情
        
        // 记录textView当前的富文本
        NSMutableAttributedString *oldAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        
        // 拼接图片名
        NSString *imageName = [NSString stringWithFormat:@"%@/%@",emoticonModel.path,emoticonModel.png];
        // 从emoticonBundle中获取图片
        UIImage *image = [UIImage imageNamed:imageName inBundle:[JSEmoticonTool shared].emoticonsBundle compatibleWithTraitCollection:nil];
        
        // 实例化文本附件
        JSEmoticonTextAttachment *textAttachment = [[JSEmoticonTextAttachment alloc] init];
        // 属性赋值
        textAttachment.emoticonModel = emoticonModel;
        // 设置图片
        textAttachment.image = image;
        // 设置bounds 注意点一
        textAttachment.bounds = CGRectMake(0, -4, self.textView.font.lineHeight, self.textView.font.lineHeight);
        // 创建富文本
        NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        // 获取选中光标位置
        NSRange selectedRange = self.textView.selectedRange;
        // 拼接富文本数据
        [oldAttributedString replaceCharactersInRange:selectedRange withAttributedString:attributedString];
        // 设置富文本font 注意点二
        [oldAttributedString addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, oldAttributedString.length)];
        // 设置富文本
        self.textView.attributedText = oldAttributedString;
        // 更改选中光标位置
        self.textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0);
        
        // 设置TextView的占位文字隐藏
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView userInfo:nil];
        
        // 设置右侧导航按钮的可选
        [self.textView.delegate textViewDidChange:self.textView];
    }
    
}





#pragma mark
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    // 压缩图片
    UIImage *scaleImage = [self scaleImage:image withExpectWidth:itemSize];
    
    // 添加图片
    [self.pictureView insertImage:scaleImage];
    
    // 释放控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark
#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    // 有内容时发布按钮可以被点击
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
    // 设置占位文字的显示和隐藏 (使用通知)
    //self.textView.placeholderHidden = textView.hasText;
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
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, displayString.length - 1)];
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
        
        
    }
    return _composeToolBar;
}

- (JSComposePictureView *)pictureView {
    
    if (_pictureView == nil) {
        _pictureView = [[JSComposePictureView alloc] init];
    }
    return _pictureView;
}

- (JSEmoticonKeyboardView *)keyboardView {
    
    if (_keyboardView == nil) {
        _keyboardView = [[JSEmoticonKeyboardView alloc] init];
        _keyboardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kKeyboardViewHeigth);
    }
    return _keyboardView;
}



@end
