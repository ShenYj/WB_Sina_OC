//
//  JSBaseViewController.m
//  BaseViewController
//
//  Created by ShenYj on 2016/11/17.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

#import "JSBaseViewController.h"
#import "JSNavigationController.h"


static CGFloat const kNavigationBarHeight = 64.f;  /** 自定义导航条高度 */

@interface JSBaseViewController () 



@end

@implementation JSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    
    [self loadData];
}

#pragma mark
#pragma mark - 请求数据 子类具体处理
- (void)loadData {
    
}

#pragma mark
#pragma mark - set up UI

/** 设置标题 */ 
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.js_navigationItem.title = title;
}

/** 设置UI */
- (void)setUpUI {
    [self prepareCustomNavigationBar];
    [self prepareView];
    [self prepareTableView];
}
/** 主视图相关 */
- (void)prepareView {
    self.view.backgroundColor = [UIColor whiteColor];
}

/** 导航条视图 */
- (void)prepareCustomNavigationBar {
    
    // 取消穿透
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.js_NavigationBar];
    self.js_NavigationBar.items = @[self.js_navigationItem];
    self.js_NavigationBar.barTintColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    [self.js_NavigationBar setTitleTextAttributes:@{
                                                    NSFontAttributeName: [UIFont systemFontOfSize:18],
                                                    NSForegroundColorAttributeName: [UIColor orangeColor]}
     ];
    
}

/** 设置表格视图 */
- (void)prepareTableView {
    
    [self.view insertSubview:self.tableView belowSubview:self.js_NavigationBar];

    self.tableView.contentInset = UIEdgeInsetsMake(self.js_NavigationBar.bounds.size.height, 0, self.tabBarController.tabBar.bounds.size.height, 0);
    
    // 使用自定义JSRefresh实现下拉刷新
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    // 使用UIActivityIndicatorView实现上拉刷新功能
    self.tableView.tableFooterView = self.activityIndicatorView;
}

#pragma mark
#pragma mark - Table view data source
/** 基类不负责数据实现,只负责准备方法,指定的数据源由子类处理 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 只是保证不出现语法错误
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSInteger section = tableView.numberOfSections -1;
    NSInteger row = indexPath.row;
    
    if (section < 0 || row < 0) {
        return;
    }
    if (row == ([tableView numberOfRowsInSection:section] -1) && !self.activityIndicatorView.isAnimating) {
        
        [self.activityIndicatorView startAnimating];
        self.isPullingUp = self.activityIndicatorView.isAnimating;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 上拉加载更多数据
            [self loadData];
        });
    }
    
}



#pragma mark
#pragma mark - lazy

- (UINavigationBar *)js_NavigationBar {
    
    if (!_js_NavigationBar) {
        _js_NavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kNavigationBarHeight)];
    }
    return _js_NavigationBar;
}

- (UINavigationItem *)js_navigationItem {
    
    if (!_js_navigationItem) {
        _js_navigationItem = [[UINavigationItem alloc] init];
    }
    return _js_navigationItem;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

// 下拉刷新指示条
- (JSRefresh *)refreshControl {
    
    if (_refreshControl == nil) {
        _refreshControl = [[JSRefresh alloc] init];
    }
    return _refreshControl;
}

// 上拉刷新指示器
- (UIActivityIndicatorView *)activityIndicatorView {
    
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.color = THEME_COLOR;
    }
    return _activityIndicatorView;
}

@end
