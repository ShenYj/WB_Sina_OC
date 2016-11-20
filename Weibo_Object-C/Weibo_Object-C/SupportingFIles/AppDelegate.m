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
#import <Bugly/Bugly.h>
#import "AFNetworkReachabilityManager.h"
#import "JSSQLDAL.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Bugly
    [Bugly startWithAppId:@"02fe94de4d"];
    
    sleep(2);
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
    // 监听kChangeRootViewControllerNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootViewController:) name:[JSUserAccountTool sharedManager].kChangeRootViewControllerNotification object:nil];
    // 监听网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"AFNetworkReachabilityStatusUnknown");
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"AFNetworkReachabilityStatusNotReachable");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
//                break;
//            default:
//                break;
//        }
//    }];
    
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
    [JSSQLDAL deleteCache];
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
