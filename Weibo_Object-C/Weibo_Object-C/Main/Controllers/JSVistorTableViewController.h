//
//  JSVistorTableViewController.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/26.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSVistorView;
@interface JSVistorTableViewController : UITableViewController

// 是否登录的判断标识
@property (nonatomic,assign) BOOL isLogin;

// 访客视图View
@property (nonatomic,strong) JSVistorView *vistorView;

@end
