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
#import "JSVistorView.h"

@interface JSBaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


/** 自定义导航条 */
@property (nonatomic,strong) UINavigationBar *js_NavigationBar;
/** 自定义导航条Item */
@property (nonatomic,strong) UINavigationItem *js_navigationItem;

/** 表格视图 */
@property (nonatomic,strong) UITableView *tableView;

/** 是否正在上拉刷新 */
@property (nonatomic,assign) BOOL isPullingUp;
/** 下拉刷新 */
@property (nonatomic) JSRefresh *refreshControl;
/** 上拉刷新指示控件 */ 
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

// 是否登录的标识
@property (nonatomic,assign,getter=isLogin) BOOL login;
// 访客视图View
@property (nonatomic,strong) JSVistorView *vistorView;

/** 请求数据 由子类具体实现 */
- (void)loadData;



@end
