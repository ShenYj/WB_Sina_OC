//
//  AppDelegate.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "AppDelegate.h"
#import "JSRootTabBarController.h"
#import "JSWelComeViewController.h"
#import "JSUserAccountTool.h"
//#import <Bugly/Bugly.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkReachabilityManager.h"
#import "JSSQLDAL.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Bugly
    //[Bugly startWithAppId:@"02fe94de4d"];
    
    // 获取MAN服务
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    // 打开调试日志，线上版本建议关闭
    [man turnOnDebug];
    // 初始化MAN，无需输入配置信息
    [man autoInit];
    // appVersion默认从Info.list的CFBundleShortVersionString字段获取，如果没有指定，可在此调用setAppversion设定
    // 如果上述两个地方都没有设定，appVersion为"-"
    [man setAppVersion:@"2.3.1"];
    // 设置渠道（用以标记该app的分发渠道名称），如果不关心可以不设置即不调用该接口，渠道设置将影响控制台【渠道分析】栏目的报表展现。
    [man setChannel:@"50"];
    
    sleep(2);
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 用户授权
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
    [application registerUserNotificationSettings:settings];
    // 监听kChangeRootViewControllerNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeRootViewController:)
                                                 name:[JSUserAccountTool sharedManager].kChangeRootViewControllerNotification
                                               object:nil];
    
    //application.networkActivityIndicatorVisible = YES;
    //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    // 监听网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 设置根控制器
    [self setupRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupRootViewController{
    if ( [JSUserAccountTool sharedManager].isLogin ) {
        self.window.rootViewController = [[JSWelComeViewController alloc] init];
    } else {
        self.window.rootViewController = [[JSRootTabBarController alloc]init];
    }
}

- (void)changeRootViewController:(NSNotification *)notification {
    if (notification.object) {
        self.window.rootViewController = [[JSWelComeViewController alloc] init];
    } else {
        self.window.rootViewController = [[JSRootTabBarController alloc] init];
    }
}

- (void)getLocalData {
    NSString *uid = [JSUserAccountTool sharedManager].userAccountModel.uid;
    if (!uid) {
        return;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //NSLog(@"%s",__FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 进入后台后清理缓存
    //[JSSQLDAL deleteCache];
    //NSLog(@"%s",__FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //NSLog(@"%s",__FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //NSLog(@"%s",__FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //NSLog(@"%s",__FUNCTION__);
}

@end
