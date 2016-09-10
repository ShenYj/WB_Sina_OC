//
//  JSOAthenViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/30.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//


#pragma mark - 常量
static NSString * const kAppKey = @"3071143364";
static NSString * const kAppSecret = @"Secret：dc2478f9204b2551d8ff7dba427d576e";
static NSString * const kRedirect_URI = @"http://www.jianshu.com/users/5ec5747435a2/latest_articles";


#import "JSOAuthenViewController.h"
#import <WebKit/WebKit.h>

@interface JSOAuthenViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation JSOAuthenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self preapareNavigationBar];
    
    [self getCode];
    
}

- (void)loadView{
    
    self.view = self.webView;
}

#pragma mark - 获取Code码
- (void)getCode{
    
//    https://api.weibo.com/oauth2/authorize?client_id=\(APPKEY)&redirect_uri=\(REDIRECT_URI)
//    NSURLRequest *request = [NSURLRequest requestWithURL:(nonnull NSURL *)]
    
}


#pragma mark - navigationBar

- (void)preapareNavigationBar{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButtonItem:)];
}

#pragma mark - target

- (void)clickLeftBarButtonItem:(UIBarButtonItem *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - lazy

- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        //[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@)",kAppKey,kRedirect_URI]
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@)",kAppKey,kRedirect_URI]]];
        [_webView loadRequest:request];
    }
    return _webView;
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
