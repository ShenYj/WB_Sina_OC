//
//  JSTabBarController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSTabBar.h"
#import "JSTabBarController.h"
#import "JSBaseNavigationController.h"
#import "JSHomeViewController.h"
#import "JSComposeRootViewController.h"
#import "JSMessageViewController.h"
#import "JSDescoveryViewController.h"
#import "JSProfileViewController.h"
//#import "JSMessageTableViewController.h"
//#import "JSHomeTableViewController.h"
//#import "JSDescoveryTableViewController.h"
//#import "JSProfileTableViewController.h"



@interface JSTabBarController () <JSTabBarDelegate>

@end

@implementation JSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    JSTabBar *tabBar = [[JSTabBar alloc]init];
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];

    JSHomeViewController *homeTvc = [[JSHomeViewController alloc]init]; // JSHomeBaseViewController
    JSMessageViewController *messageTvc = [[JSMessageViewController alloc]init];
    JSDescoveryViewController *descoveryTvc = [[JSDescoveryViewController alloc]init];
    JSProfileViewController *profileTvc = [[JSProfileViewController alloc]init];
    
    [self loadNavigationControllerWithViewController:homeTvc withTitle:@"首页" withTabBarImageName:@"tabbar_home"];
    [self loadNavigationControllerWithViewController:messageTvc withTitle:@"消息" withTabBarImageName:@"tabbar_message_center"];
    [self loadNavigationControllerWithViewController:descoveryTvc withTitle:@"发现" withTabBarImageName:@"tabbar_discover"];
    [self loadNavigationControllerWithViewController:profileTvc withTitle:@"我" withTabBarImageName:@"tabbar_profile"];
//    self.tabBar.barTintColor = [UIColor orangeColor];
    self.tabBar.tintColor = THEME_COLOR;//设置图片\文字的颜色(不带渲染)
}

/** 设置朝向 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)loadNavigationControllerWithViewController:(UIViewController *)viewController withTitle:(NSString *)title withTabBarImageName:(NSString *)imageName{
    
    UIImage *img_Normal = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //UIImage *img_Select = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    UIImage *img_Normal = [UIImage imageNamed:imageName];
    UIImage *img_Select = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    //[viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: THEME_COLOR} forState:UIControlStateSelected];
    
    JSBaseNavigationController *navigationController = [[JSBaseNavigationController alloc]initWithRootViewController:viewController];
    // 设置底部bar在Push时隐藏
    navigationController.bottomBarHiddenWhenPushed = YES;
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
    JSBaseNavigationController *navigationController = [[JSBaseNavigationController alloc]initWithRootViewController:composeVC];
    
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
