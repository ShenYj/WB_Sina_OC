//
//  JSHomeViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeViewController.h"
#import "JSNextDemoViewController.h"

@implementation JSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareNavView];
}

/** 设置视图 */
- (void)prepareNavView {
    self.js_navigationItem.title = @"首页";
    self.js_navigationItem.leftBarButtonItem = [[JSBaseNavBarButtonItem alloc] initWithTitle:@"首页" withFont:16 withTarget:self withAction:@selector(clickLeftBarButtonItem:)];
    
}

/** 右侧导航栏按钮点击事件 */
- (void)clickLeftBarButtonItem:(JSBaseNavBarButtonItem *)sender {
    JSNextDemoViewController *nextVC = [[JSNextDemoViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
