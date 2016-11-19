//
//  JSHomeViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeViewController.h"
#import "JSNextDemoViewController.h"
#import "JSHomeTableViewController.h"
#import "JSNetworkTool.h"
#import "JSHomeStatusModel.h"
#import "JSStatusCell.h"
#import "JSStatusTipCell.h"
#import "JSSQLDAL.h"


static NSString * const homeTableCellReusedId = @"homeTableCellReusedId";
static NSString * const homeTableCellTipReusedId = @"homeTableCellTipReusedId";
static CGFloat const kPullDownLabelHeight = 34.f; // 下拉刷新展示更新多少条数据Label的高度

@interface JSHomeViewController ()
// 微博数据容器
@property (nonatomic,strong) NSArray  <JSHomeStatusModel *> *homeStatusDatas;
// 展示更新微博条数
@property (nonatomic) UILabel *pullDownStatusCountsLabel;
@end

@implementation JSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachablityDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    // 注册cell
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[JSStatusTipCell class] forCellReuseIdentifier:homeTableCellTipReusedId];
    [self.tableView registerClass:[JSStatusCell class] forCellReuseIdentifier:homeTableCellReusedId];
    
    [self prepareNavView];
    
}

// 网络发生变化
- (void)networkReachablityDidChanged:(NSNotification *)notification {
    // 刷新数据源
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)loadData {
    // 准备数据
    [self loadHomeStatusDataByIsPulling:self.isPullingUp];
}

/**  请求首页数据 since_id  若指定此参数 -->下拉  && max_id	 若指定此参数 -->上拉*/
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
        [self.view insertSubview:self.pullDownStatusCountsLabel belowSubview:self.js_NavigationBar];
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

/** 设置导航栏视图 */
- (void)prepareNavView {
    self.js_navigationItem.title = @"首页";
    self.js_navigationItem.leftBarButtonItem = [[JSBaseNavBarButtonItem alloc] initWithTitle:@"首页" withFont:16 withTarget:self withAction:@selector(clickLeftBarButtonItem:)];
    
}

/** 右侧导航栏按钮点击事件 */
- (void)clickLeftBarButtonItem:(JSBaseNavBarButtonItem *)sender {
    JSNextDemoViewController *nextVC = [[JSNextDemoViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}


#pragma mark
#pragma mark - 重写基类的数据源方法
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

#pragma mark
#pragma mark - lazy

- (NSArray  <JSHomeStatusModel *> *)homeStatusDatas {
    if (!_homeStatusDatas) {
        _homeStatusDatas = @[];
    }
    return _homeStatusDatas;
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