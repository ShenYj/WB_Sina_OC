//
//  JSTabBar.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/25.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSTabBar;
//声明协议
@protocol JSTabBarDelegate <NSObject>

@optional
//声明代理方法
- (void)tabBarDelegateWithTabBar:(JSTabBar *)tabBar;

@end

@interface JSTabBar : UITabBar
//声明代理对象
@property (nonatomic,weak) id tabBarDelegate;
@end
