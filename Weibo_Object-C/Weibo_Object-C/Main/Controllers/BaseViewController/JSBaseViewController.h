//
//  JSBaseViewController.h
//  BaseViewController
//
//  Created by ShenYj on 2016/11/17.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBaseNavBarButtonItem.h"
#import "JSRefresh.h"
#import "JSRefreshControl.h"
#import "JSVistorView.h"
#import "JSNavigationBar.h"

@interface JSBaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

// 是否登录的标识
@property (nonatomic,assign,getter=isLogin) BOOL login;
/** 自定义导航条 */
@property (nonatomic,strong) JSNavigationBar *js_NavigationBar;
/** 自定义导航条Item */
@property (nonatomic,strong) UINavigationItem *js_navigationItem;


/** 下拉刷新 */
//@property (nonatomic) JSRefresh *refreshControl;
/** 下拉刷新控件02 */
@property (nonatomic) JSRefreshControl *refreshControl;
/** 上拉刷新指示控件 */ 
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

/** 表格视图 */
@property (nonatomic,strong) UITableView *tableView;
// 访客视图View
@property (nonatomic,strong) JSVistorView *vistorView;
/** 访客视图参数 */
@property (nonatomic,strong) NSDictionary *userInfo;

/** 请求数据 由子类具体实现 */
- (void)loadDataWithIsPulling:(BOOL)isPulling;
/** 设置登录后的表格视图: 在适当的地方重写父类方法或空实现来重新自定义视图 */
- (void)prepareTableView;



@end
