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
#import "JSNavigationController.h"

@interface JSDemoViewController : UIViewController

@end
@implementation JSDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor js_randomColor];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    
    JSHomeNavButton *leftButton = [[JSHomeNavButton alloc] initWithTitleName:@"首页" withAction: NSSelectorFromString(@"clickLeftButton:") withTarget:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    JSHomeNavButton *rightButton = [[JSHomeNavButton alloc] initWithTitleName:@"下一个" withAction: @selector(clickRightButton:) withTarget:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)clickLeftButton:(JSHomeNavButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightButton:(JSHomeNavButton *)sender {
    JSDemoViewController *VC = [[JSDemoViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end


static NSString * const homeTableCellReusedId = @"homeTableCellReusedId";
static NSString * const homeTableCellTipReusedId = @"homeTableCellTipReusedId";
static CGFloat const kPullDownLabelHeight = 34.f; // 下拉刷新展示更新多少条数据Label的高度

@interface JSHomeTableViewController ()

// 当前登录用户及其所关注（授权）用户的最新微博数据
@property (nonatomic) NSArray <JSHomeStatusModel *> *homeStatusDatas;
// 上拉刷新指示控件
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
// 下拉刷新
@property (nonatomic) JSRefresh *refreshControl;
// 展示更新微博条数
@property (nonatomic) UILabel *pullDownStatusCountsLabel;

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
    
    __weak typeof(self) weakSelf = self;
    
    // 左侧导航栏按钮
    JSHomeNavButton *navitionLeftButton = [[JSHomeNavButton alloc] initWithName:@"navigationbar_friendsearch"];
    [navitionLeftButton setClickHandler:^{
        JSDemoViewController *VC = [[JSDemoViewController alloc] init];
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navitionLeftButton];
    // 右侧导航栏按钮
    JSHomeNavButton *navigationRightButton = [[JSHomeNavButton alloc] initWithName:@"navigationbar_pop"];
    [navigationRightButton setClickHandler:^{
        UIViewController *VC = [[UIViewController alloc] init];
        [weakSelf.navigationController pushViewController:VC animated:YES];
    }];
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
    
    // 检查是否有本地数据,如果没有,请求网络数据
    [JSSQLDAL checkLocalCacheWithSinceid:sinceId withMaxid:maxId withFinishedBlock:^(id obj, NSError *error) {
        
        NSArray <JSHomeStatusModel *>*statusData = (NSArray <JSHomeStatusModel *>*)obj;
        if (isPulling) {
            
            // 上拉加载更多
            self.homeStatusDatas = [self.homeStatusDatas arrayByAddingObjectsFromArray:statusData];
            
        } else {
            
            // 下拉刷新
            self.homeStatusDatas = [statusData arrayByAddingObjectsFromArray:self.homeStatusDatas];
            
            // 显示更新多少条微博数据
            [self pullDownAnimationWithStatusCounts:statusData.count];
        }
        
        [self.tableView reloadData];
        
    }];
    
    
}

// 下拉刷新动画 (展示更新多少条微博数据)
- (void)pullDownAnimationWithStatusCounts:(NSInteger)counts {
    
    if (self.pullDownStatusCountsLabel.superview == nil) {
        
        self.pullDownStatusCountsLabel.text = [NSString stringWithFormat:@"本次更新%zd条微博",counts];
        [self.navigationController.view insertSubview:self.pullDownStatusCountsLabel belowSubview:self.navigationController.navigationBar];
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        self.pullDownStatusCountsLabel.transform = CGAffineTransformTranslate(self.pullDownStatusCountsLabel.transform, 0, kPullDownLabelHeight);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.pullDownStatusCountsLabel.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            [self.pullDownStatusCountsLabel removeFromSuperview];
        }];
        
    }];
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
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.drawsAsynchronously = YES;
    
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
// 展示下拉刷新微博条数
- (UILabel *)pullDownStatusCountsLabel {
    
    if (_pullDownStatusCountsLabel == nil) {
        _pullDownStatusCountsLabel = [[UILabel alloc] init];
        _pullDownStatusCountsLabel.frame = CGRectMake(0, 64-kPullDownLabelHeight, SCREEN_WIDTH, kPullDownLabelHeight);
        _pullDownStatusCountsLabel.font = [UIFont systemFontOfSize:16];
        _pullDownStatusCountsLabel.textAlignment = NSTextAlignmentCenter;
        _pullDownStatusCountsLabel.textColor = THEME_COLOR;
        _pullDownStatusCountsLabel.backgroundColor = [UIColor orangeColor];
    }
    return _pullDownStatusCountsLabel;
}

@end
