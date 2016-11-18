//
//  JSTabBarController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSTabBar.h"
#import "JSTabBarController.h"
#import "JSNavigationController.h"
#import "JSHomeViewController.h"
//#import "JSHomeTableViewController.h"
#import "JSComposeRootViewController.h"
#import "JSMessageTableViewController.h"
#import "JSProfileTableViewController.h"
#import "JSDescoveryTableViewController.h"



@interface JSTabBarController () <JSTabBarDelegate>

@end

@implementation JSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    JSTabBar *tabBar = [[JSTabBar alloc]init];
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];

    JSHomeViewController *homeTvc = [[JSHomeViewController alloc]init]; // JSHomeBaseViewController
    JSMessageTableViewController *messageTvc = [[JSMessageTableViewController alloc]init];
    JSDescoveryTableViewController *descoveryTvc = [[JSDescoveryTableViewController alloc]init];
    JSProfileTableViewController *profileTvc = [[JSProfileTableViewController alloc]init];
    
    [self loadNavigationControllerWithViewController:homeTvc withTitle:@"首页" withTabBarImageName:@"tabbar_home"];
    [self loadNavigationControllerWithViewController:messageTvc withTitle:@"消息" withTabBarImageName:@"tabbar_message_center"];
    [self loadNavigationControllerWithViewController:descoveryTvc withTitle:@"发现" withTabBarImageName:@"tabbar_discover"];
    [self loadNavigationControllerWithViewController:profileTvc withTitle:@"我" withTabBarImageName:@"tabbar_profile"];
//    self.tabBar.barTintColor = [UIColor orangeColor];
    self.tabBar.tintColor = THEME_COLOR;//设置图片\文字的颜色(不带渲染)
}

- (void)loadNavigationControllerWithViewController:(UIViewController *)viewController withTitle:(NSString *)title withTabBarImageName:(NSString *)imageName{
    
    UIImage *img_Normal = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //UIImage *img_Select = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    UIImage *img_Normal = [UIImage imageNamed:imageName];
    UIImage *img_Select = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    //[viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: THEME_COLOR} forState:UIControlStateSelected];
    
    JSNavigationController *navigationController = [[JSNavigationController alloc]initWithRootViewController:viewController];
    viewController.title = title;
    viewController.tabBarItem.image = img_Normal;
    viewController.tabBarItem.selectedImage = img_Select;
    [self addChildViewController:navigationController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
#pragma mark JSTabBarDelegate

- (void)tabBarDelegateWithTabBar:(JSTabBar *)tabBar {
    
    // 弹出发布微博界面
    JSComposeRootViewController *composeVC = [[JSComposeRootViewController alloc] init];
    JSNavigationController *navigationController = [[JSNavigationController alloc]initWithRootViewController:composeVC];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
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
