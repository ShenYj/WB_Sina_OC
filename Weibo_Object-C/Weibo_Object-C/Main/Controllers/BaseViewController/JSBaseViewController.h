//
//  JSBaseViewController.h
//  BaseViewController
//
//  Created by ShenYj on 2016/11/17.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBaseNavBarButtonItem.h"

@interface JSBaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


/** 自定义导航条 */
@property (nonatomic,strong) UINavigationBar *js_NavigationBar;
/** 自定义导航条Item */
@property (nonatomic,strong) UINavigationItem *js_navigationItem;

// 表格视图
@property (nonatomic,strong) UITableView *tableView;

/** 请求数据 由子类具体实现 */
- (void)loadData;

@end
