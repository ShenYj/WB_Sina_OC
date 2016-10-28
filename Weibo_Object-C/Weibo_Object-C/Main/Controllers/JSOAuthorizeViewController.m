//
//  JSOAthenViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/30.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#pragma mark - 常量
static NSString * const kAppKey = @"3071143364";
static NSString * const kAppSecret = @"dc2478f9204b2551d8ff7dba427d576e";
static NSString * const kRedirect_URI = @"http://www.jianshu.com/users/5ec5747435a2/latest_articles";
static NSString * const kTestAccount = @"18519153799";
static NSString * const kTestPassword = @"qwertyuiop123";

#import "JSOAuthorizeViewController.h"
#import "JSUserAccountTool.h"
#import <WebKit/WebKit.h>
#import "JSNetworkTool.h"

@interface JSOAuthorizeViewController () <WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation JSOAuthorizeViewController

- (void)loadView {
    
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self preapareNavigationBar];
    
}

#pragma mark - navigationBar

- (void)preapareNavigationBar{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButtonItem:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自动填充" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem:)];
}

#pragma mark - target

// 左侧导航栏按钮点击事件(登录)
- (void)clickLeftBarButtonItem:(UIBarButtonItem *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 右侧导航栏按钮点击事件(自动填充)
- (void)clickRightBarButtonItem:(UIBarButtonItem *)sender{
    
    NSString *autoFill = [NSString stringWithFormat:@"document.getElementById('userId').value='%@',document.getElementById('passwd').value='%@'",kTestAccount,kTestPassword];
    
    //[self.webView stringByEvaluatingJavaScriptFromString:autoFill];
    [self.webView evaluateJavaScript:autoFill completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
    
}

#pragma mark - WKNavigationDelegate
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if ([navigationAction.request.URL.absoluteString hasPrefix:kRedirect_URI]) {

        NSRange range = [navigationAction.request.URL.absoluteString rangeOfString:@"code="];

        NSString *code = [navigationAction.request.URL.absoluteString substringFromIndex:range.location + range.length];


        __weak typeof(self) weakSelf = self;
        // 获取Token
        [[JSNetworkTool sharedNetworkTool] loadAccessTokenWithCode:code withFinishedBlock:^(id obj, NSError *error) {

            if (error || obj == nil) {
                NSLog(@"请求失败:%@",error);
                return ;
            }

            // 将用户信息转模型
            JSUserAccountModel *model = [JSUserAccountModel yy_modelWithDictionary:obj];

            [weakSelf loadUserInfoWithUserAccount:model];

        }];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }

    decisionHandler(WKNavigationActionPolicyAllow);
    
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    
    if (error) {
        NSLog(@"请求失败:%@",error);
    }
    
}


#pragma mark - UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//    
//    
//    if ([request.URL.absoluteString hasPrefix:kRedirect_URI]) {
//        
//        NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
//        
//        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
//        
//        
//        __weak typeof(self) weakSelf = self;
//        // 获取Token
//        [[JSNetworkTool sharedNetworkTool] loadAccessTokenWithCode:code withFinishedBlock:^(id obj, NSError *error) {
//           
//            if (error || obj == nil) {
//                NSLog(@"请求失败:%@",error);
//                return ;
//            }
//            
//            // 将用户信息转模型
//            JSUserAccountModel *model = [JSUserAccountModel yy_modelWithDictionary:obj];
//            
//            [weakSelf loadUserInfoWithUserAccount:model];
//            
//        }];
//        
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
// 
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    
//    if (error) {
//        
//        NSLog(@"%@",error);
//    }
//    
//}



#pragma mark - 获取用户信息
- (void)loadUserInfoWithUserAccount:(JSUserAccountModel *)userAccount {
    
    // 获取用户信息
    [[JSNetworkTool sharedNetworkTool] loadUserAccountInfo:userAccount withFinishedBlock:^(id obj, NSError *error) {
        
        if (error || obj == nil) {
            NSLog(@"请求失败:%@",error);
            return ;
        }
        
        NSLog(@"%@",obj[@"screen_name"]);
        
        [userAccount setValue:obj[@"avatar_large"] forKey:@"avatar_large"];
        [userAccount setValue:obj[@"screen_name"] forKey:@"screen_name"];
        
        // 存入UserAccountTool中并本地化存储
        [[JSUserAccountTool sharedManager] saveUserAccount:userAccount];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            // 关闭遮罩
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[JSUserAccountTool sharedManager].kChangeRootViewControllerNotification object:@"OAuth" userInfo:nil];
            
        }];
        
    }];
    

}


#pragma mark - lazy

- (WKWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        //_webView.delegate = self;
        //https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",kAppKey,kRedirect_URI]]];
        [_webView loadRequest:request];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


