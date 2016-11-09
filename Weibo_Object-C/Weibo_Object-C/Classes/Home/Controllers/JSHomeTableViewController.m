//
//  JSHomeTableViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeTableViewController.h"
#import "JSVistorView.h"
#import "JSUserAccountTool.h"
#import "JSRefresh.h"
#import "JSNetworkTool.h"
#import "JSHomeStatusModel.h"
#import "JSStatusCell.h"
#import "JSStatusTipCell.h"
#import "JSHomeNavButton.h"
#import "JSSQLDAL.h"

static NSString * const homeTableCellReusedId = @"homeTableCellReusedId";
static NSString * const homeTableCellTipReusedId = @"homeTableCellTipReusedId";

@interface JSHomeTableViewController ()

// 当前登录用户及其所关注（授权）用户的最新微博数据
@property (nonatomic) NSArray <JSHomeStatusModel *> *homeStatusDatas;
// 上拉刷新指示控件
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
// 下拉刷新
@property (nonatomic) JSRefresh *refreshControl;


@end

@implementation JSHomeTableViewController

@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isLogin) {
        
        [self.vistorView setupVistorViewInfoWithTitle:nil withImageName:nil];
    } else {
        
        [self prepareView];
        [self prepareNavigationView];
    }
    
}

- (void)prepareView {
    
    // 监听网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachablityDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    // 使用Status模型类记录行高
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 200.f;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[JSStatusTipCell class] forCellReuseIdentifier:homeTableCellTipReusedId];
    [self.tableView registerClass:[JSStatusCell class] forCellReuseIdentifier:homeTableCellReusedId];
    
    // 使用自定义JSRefresh实现下拉刷新
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 使用UIActivityIndicatorView实现上拉刷新功能
    self.tableView.tableFooterView = self.activityIndicatorView;
    
    // 首次展示首页请求数据
    [self loadHomeStatusDataByIsPulling:self.activityIndicatorView.isAnimating];
    
    

}

// 设置导航栏按钮
- (void)prepareNavigationView {
    
    // 左侧导航栏按钮
    JSHomeNavButton *navitionLeftButton = [[JSHomeNavButton alloc] initWithName:@"navigationbar_friendsearch"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navitionLeftButton];
    // 右侧导航栏按钮
    JSHomeNavButton *navigationRightButton = [[JSHomeNavButton alloc] initWithName:@"navigationbar_pop"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navigationRightButton];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - loadHomeStatusData
/*
    since_id  若指定此参数 -->下拉
     max_id	  若指定此参数 -->上拉
 */
- (void)loadHomeStatusDataByIsPulling:(BOOL)isPulling {
    
    // 停止动画
    [self.activityIndicatorView stopAnimating];
    [self.refreshControl endRefresh];
    
    NSInteger sinceId = 0;
    NSInteger maxId = 0;
    
    if (isPulling) {
        
        // 上拉加载更多
        maxId = self.homeStatusDatas.lastObject.wb_id.integerValue;
        
        if (maxId > 0) {
            // 上拉加载更多,返回ID小于或等于max_id的微博
            maxId -= 1;
        }
        
    } else {
        //  下拉刷新
        sinceId = self.homeStatusDatas.firstObject.wb_id.integerValue;
        
    }
    
    [[JSNetworkTool sharedNetworkTool] loadHomePublicDatawithFinishedBlock:^(id obj, NSError *error) {
        
        NSArray *statusDataArr = (NSArray *)obj;
        
        // 数据库存储
        [JSSQLDAL saveCache:statusDataArr];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        for (NSDictionary *dict in statusDataArr) {
            
            JSHomeStatusModel *model = [JSHomeStatusModel statuWithDict:dict];
            [mArr addObject:model];
            
        }
        
        if (isPulling) {
            
            // 上拉加载更多
            self.homeStatusDatas = [self.homeStatusDatas arrayByAddingObjectsFromArray:mArr];
            
        } else {
            
            // 下拉刷新
            self.homeStatusDatas = [mArr arrayByAddingObjectsFromArray:self.homeStatusDatas];
            
        }
        
        [self.tableView reloadData];
        
    } Since_id:sinceId max_id:maxId];
    
    
}

// 下拉刷新
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadHomeStatusDataByIsPulling:self.activityIndicatorView.isAnimating];
    });
    
}

// 网络发生变化
- (void)networkReachablityDidChanged:(NSNotification *)notification {
    // 刷新数据源
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark
#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [JSNetworkTool sharedNetworkTool].reachabilityManager.reachable ? 0 : 1;
    }

    return self.homeStatusDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JSHomeStatusModel *dataModel = self.homeStatusDatas[indexPath.row];
    
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:homeTableCellTipReusedId forIndexPath:indexPath];
    }
    
    JSStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:homeTableCellReusedId forIndexPath:indexPath];
    
    cell.statusData = dataModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 44;
    }

    JSHomeStatusModel *statusModel = self.homeStatusDatas[indexPath.row];
    
    return statusModel.homeStatusRowHeigh;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // 最后一个Cell显示 && 动画没有开启
    if (indexPath.row == self.homeStatusDatas.count - 1 && !self.activityIndicatorView.isAnimating) {
        
        [self.activityIndicatorView startAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 开始请求新数据(较早时间的数据)
            [self loadHomeStatusDataByIsPulling:self.activityIndicatorView.isAnimating];
        });
        
    }
    
}

#pragma mark 
#pragma mark - lazy

// 数据容器
- (NSArray<JSHomeStatusModel *> *)homeStatusDatas {
    
    if (_homeStatusDatas == nil) {
        _homeStatusDatas = [NSArray array];
    }
    return _homeStatusDatas;
}

// 上拉刷新指示器
- (UIActivityIndicatorView *)activityIndicatorView {
    
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.color = THEME_COLOR;
    }
    return _activityIndicatorView;
}
// 下拉刷新指示条
- (JSRefresh *)refreshControl {
    
    if (_refreshControl == nil) {
        _refreshControl = [[JSRefresh alloc] init];
    }
    return _refreshControl;
}

@end
