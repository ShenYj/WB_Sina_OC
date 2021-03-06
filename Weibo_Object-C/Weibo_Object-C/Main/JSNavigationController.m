//
//  JSNavigationController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSNavigationController.h"

@interface JSNavigationController ()

@end

@implementation JSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationBar.hidden = YES;
    
    // 使用自定义navigationBar
    self.navigationBar.translucent = NO;// 设置bar不透明
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = THEME_COLOR;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}

// push时隐藏底部TabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
        
        if (self.childViewControllers.count > 1) {
            viewController.navigationItem.leftBarButtonItem.title = @"首页";
        }
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
