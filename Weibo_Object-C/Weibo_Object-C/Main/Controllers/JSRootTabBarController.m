//
//  JSTabBarController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSTabBar.h"
#import "JSRootTabBarController.h"
#import "JSBaseNavigationController.h"
#import "JSHomeViewController.h"
#import "JSComposeRootViewController.h"
#import "JSMessageViewController.h"
#import "JSDescoveryViewController.h"
#import "JSProfileViewController.h"
#import "JSNetworkTool+JSUnreadExtension.h"
#import "JSUserAccountTool.h"
#import "JSComposeView.h"

//#import "JSMessageTableViewController.h"
//#import "JSHomeTableViewController.h"
//#import "JSDescoveryTableViewController.h"
//#import "JSProfileTableViewController.h"


extern CGFloat const kNavigationBarHeight;   /** 自定义导航条高度 */

@interface JSRootTabBarController () <JSTabBarDelegate,UITabBarControllerDelegate>

/** 更新未读消息的定时器 */
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation JSRootTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    NSArray <NSDictionary *>*subVCInfo =  @[
                                                 @{
                                                     // 子控制器视图参数
                                                     @"className": @"JSHomeViewController",
                                                     @"title": @"首页",
                                                     @"tabBarImg": @"tabbar_home",
                                                     // 访客视图信息
                                                     @"message": @"",
                                                     @"imageName": @""
                                                     },
                                                 @{
                                                     @"className": @"JSMessageViewController",
                                                     @"title": @"消息",
                                                     @"tabBarImg": @"tabbar_message_center",
                                                     @"message": @"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过",
                                                     @"imageName": @"visitordiscover_image_message"
                                                     },
                                                 @{
                                                     @"className": @"JSDescoveryViewController",
                                                     @"title": @"发现",
                                                     @"tabBarImg": @"tabbar_discover",
                                                     @"message": @"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过",
                                                     @"imageName": @"visitordiscover_image_message"
                                                     },
                                                 @{
                                                     @"className": @"JSProfileViewController",
                                                     @"title": @"我",
                                                     @"tabBarImg": @"tabbar_profile",
                                                     @"message": @"登录后，你的微博、相册、个人资料会显示在这里，展示给别人",
                                                     @"imageName": @"visitordiscover_image_profile"
                                                     },
                                            ];

    JSTabBar *tabBar = [[JSTabBar alloc]init];
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    
    for (int i = 0; i < 4; i ++) {
        [self loadNavigationControllerWithInfo:subVCInfo[i]];
    }
    
    // 更新未读消息
    [self updateUnReadHomeStatus];
    
    //self.tabBar.tintColor = THEME_COLOR;//设置图片\文字的颜色(不带渲染)
}

/** 获取微博未读消息 */
- (void)updateUnReadHomeStatus {
    
    // 如果用户登录,才开启定时器请求未读消息数据
    if (![JSUserAccountTool sharedManager].isLogin) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateUnreadHomeStatusByTimer) userInfo:nil repeats:YES];

}
- (void)updateUnreadHomeStatusByTimer {
    __weak typeof(self) weakSelf = self;
    [[JSNetworkTool sharedNetworkTool] loadUnreadStatusCountsWithCompeletionHandler:^(NSInteger count) {
        
        // 设置tabBarItem badgeValue
        weakSelf.tabBar.items[0].badgeValue = count > 0 ? @(count).description : nil;// 如果设置为@""(空),将会显示成一个球形提醒
        // 设置应用图标badgeNumber
        [UIApplication sharedApplication].applicationIconBadgeNumber = count;
    }];
}


/** 设置朝向 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 实例化子控制器方法
- (void)loadNavigationControllerWithInfo:(NSDictionary *)subVCInfo {
    
    Class className = NSClassFromString(subVCInfo[@"className"]);
    JSBaseViewController *subViewController = [[className alloc] init];
    subViewController.title = subVCInfo[@"title"];
    subViewController.userInfo = subVCInfo;
    UIImage *image = [[UIImage imageNamed:subVCInfo[@"tabBarImg"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selIm = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",subVCInfo[@"tabBarImg"]]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    subViewController.tabBarItem.image = image;
    subViewController.tabBarItem.selectedImage = selIm;
    [subViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
    [subViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} forState:UIControlStateSelected];
    
    JSBaseNavigationController *navigationController = [[JSBaseNavigationController alloc]initWithRootViewController:subViewController];
    [self addChildViewController:navigationController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark 
#pragma mark JSTabBarDelegate

- (void)tabBarDelegateWithTabBar:(JSTabBar *)tabBar {
    
    // 弹出发布微博界面
//    JSComposeRootViewController *composeVC = [[JSComposeRootViewController alloc] init];
//    JSBaseNavigationController *navigationController = [[JSBaseNavigationController alloc]initWithRootViewController:composeVC];
//    [self presentViewController:navigationController animated:YES completion:nil];
    
    JSComposeView *composeView = [[JSComposeView alloc] init];
    __weak typeof(self) weakSelf = self;
    [composeView showComposeViewWithCompeletionHandler:^(NSString *clsName) {
        
        Class class = NSClassFromString(clsName);
        JSBaseViewController *viewController = [[class alloc] init];
        viewController.title = clsName;
        JSBaseNavigationController *navController = [[JSBaseNavigationController alloc] initWithRootViewController:viewController];
        [weakSelf presentViewController:navController animated:YES completion:nil];
    }];
    
    
}

#pragma mark
#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
    
//    if ([viewController isKindOfClass:[XXXController class]] ) {
//        // 还可以通过此方式解决TabBar自定义Button穿帮问题
//        return NO;
//    }
    
    if ( tabBarController.selectedViewController == viewController && tabBarController.selectedIndex == 0) {
        // 首页TabBarItem重复点击
        JSBaseNavigationController *navController = (JSBaseNavigationController *)tabBarController.childViewControllers.firstObject;
        JSHomeViewController *homeViewController = (JSHomeViewController *)navController.childViewControllers.firstObject;
        // 滚动到顶端
        //[homeViewController.tableView setContentOffset:CGPointMake(0, -kNavigationBarHeight)];
        [homeViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        dispatch_after(0.5, dispatch_get_main_queue(), ^{
            // 请求数据
            [homeViewController loadDataWithIsPulling:homeViewController.activityIndicatorView.isAnimating];
        });
       
        
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
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
