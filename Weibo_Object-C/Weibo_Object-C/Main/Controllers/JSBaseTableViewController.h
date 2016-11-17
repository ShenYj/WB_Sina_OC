//
//  JSVistorTableViewController.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/26.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSVistorView;
@interface JSBaseTableViewController : UITableViewController

// 访客视图View
@property (nonatomic,strong) JSVistorView *vistorView;
// 是否登录的标识
@property (nonatomic,assign,getter=isLogin) BOOL login;



@end
