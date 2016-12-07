//
//  JSHomeViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeViewController.h"
#import "JSNextDemoViewController.h"
#import "JSNetworkTool+JSExtension.h"
#import "JSHomeStatusModel.h"
#import "JSStatusCell.h"
#import "JSStatusTipCell.h"
#import "JSSQLDAL.h"
#import "JSHomeStatusPictureModel.h"
#import "SDWebImageManager.h"
#import <SafariServices/SafariServices.h>
#import <AudioToolbox/AudioToolbox.h>

static NSString * const homeTableCellReusedId = @"homeTableCellReusedId";
static NSString * const homeTableCellTipReusedId = @"homeTableCellTipReusedId";
static CGFloat const kPullDownLabelHeight = 34.f; // 下拉刷新展示更新多少条数据Label的高度
extern NSInteger const pullUpErrorMaxTimes;       // 上拉刷新错误的最大次数

@interface JSHomeViewController ()
// 微博数据容器
@property (nonatomic,strong) NSArray  <JSHomeStatusModel *> *homeStatusDatas;
// 展示更新微博条数
@property (nonatomic) UILabel *pullDownStatusCountsLabel;
// 上拉刷新记次
@property (nonatomic,assign) NSInteger pullUpCount;

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
    
}

// 网络发生变化
- (void)networkReachablityDidChanged:(NSNotification *)notification {
    // 刷新数据源
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/** 重写父类方法 */
- (void)prepareTableView {
    [super prepareTableView];
    [self prepareNavView];
}


/** 设置导航栏视图 */
- (void)prepareNavView {
    self.js_navigationItem.title = @"首页";
    self.js_navigationItem.leftBarButtonItem = [[JSBaseNavBarButtonItem alloc] initWithTitle:@"好友" withFont:16 withTarget:self withAction:@selector(clickLeftBarButtonItem:)];
    
}

/** 重写父类方法请求数据 */
/**  请求首页数据 since_id  若指定此参数 -->下拉  && max_id	 若指定此参数 -->上拉*/
- (void)loadDataWithIsPulling:(BOOL)isPulling {
    // 开始刷新
    [self.refreshControl beginRefresh];
    
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
    if ( isPulling && self.pullUpCount >= pullUpErrorMaxTimes ) {
        // 上上拉刷新时,请求回数据为0的次数大于等于最大尝试错误次数时,直接返回,不再请求刷新数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pullUpAnimationWithRequestFaild];
            [self.activityIndicatorView stopAnimating];
            self.pullUpCount = 0;
        });
        return;
    }
    
    [[JSNetworkTool sharedNetworkTool] loadHomePublicDatawithFinishedBlock:^(id obj, NSError *error) {
        
        NSArray <NSDictionary *>*statusData = (NSArray <NSDictionary *>*)obj;
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dict in statusData) {
            JSHomeStatusModel *model = [JSHomeStatusModel statuWithDict:dict];
            [mArr addObject:model];
        }
        
        if (isPulling) {
            if (statusData.count == 0) {
                self.pullUpCount ++;
            }
            // 上拉加载更多
            self.homeStatusDatas = [self.homeStatusDatas arrayByAddingObjectsFromArray:mArr.copy];
            // 设置应用图标badgeNumber
        } else {
            // 下拉刷新
            self.homeStatusDatas = [mArr.copy arrayByAddingObjectsFromArray:self.homeStatusDatas];
            // 显示更新多少条微博数据
            [self pullDownAnimationWithStatusCounts:statusData.count];
            dispatch_after(0.1, dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                self.tabBarItem.badgeValue = 0;
            });
        }
        // 缓存单张图片 (包含了停止动画&刷新表格)
        //[self cacheSingleImage:self.homeStatusDatas];
        // 停止动画
        [self.activityIndicatorView stopAnimating];
        [self.refreshControl endRefresh];
        // 刷新表格
        AudioServicesPlaySystemSound(1106);
        [self.tableView reloadData];
        
    } Since_id:sinceId max_id:maxId];
    
    // 检查是否有本地数据,如果没有,请求网络数据
    //    [JSSQLDAL checkLocalCacheWithSinceid:sinceId withMaxid:maxId withFinishedBlock:^(id obj, NSError *error) {
    //        NSArray <JSHomeStatusModel *>*statusData = (NSArray <JSHomeStatusModel *>*)obj;
    //        if (isPulling) {
    //
    //            if (statusData.count == 0) {
    //                self.pullUpCount ++;
    //            }
    //            // 上拉加载更多
    //            self.homeStatusDatas = [self.homeStatusDatas arrayByAddingObjectsFromArray:statusData];
    //        } else {
    //            // 下拉刷新
    //            self.homeStatusDatas = [statusData arrayByAddingObjectsFromArray:self.homeStatusDatas];
    //            // 显示更新多少条微博数据
    //            [self pullDownAnimationWithStatusCounts:statusData.count];
    //        }
    //        [self.tableView reloadData];
    //        // 设置应用图标badgeNumber
    //        dispatch_after(0.5, dispatch_get_main_queue(), ^{
    //
    //            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //            self.tabBarItem.badgeValue = 0;
    //        });
    //    }];

}

// 配图视图中,如果配图为单张,则进行缓存
- (void)cacheSingleImage:(NSArray  <JSHomeStatusModel *>*)homeStatusData {
    
    // 调度组
    dispatch_group_t group = dispatch_group_create();
    // 记录图片长度
    __block CGFloat length = 0.f;
    // 遍历数组,查找微博中有单张图片的微博,进行缓存
    for (JSHomeStatusModel *statusModel in homeStatusData) {
        // 如果配图数量不为1,不做处理
        if (statusModel.pic_urls.count != 1) {
            continue;
        }
        // 获取URL
        NSString *singleImgUrlString = statusModel.pic_urls.firstObject.thumbnail_pic;
        // 入组
        dispatch_group_enter(group);
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:singleImgUrlString] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            NSData *imageData = UIImagePNGRepresentation(image);
            length += imageData.length;
            // 更新
            [statusModel updateSingleImageSize:image];
            // 出组
            dispatch_group_leave(group);
        }];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // 停止动画
        [self.activityIndicatorView stopAnimating];
        [self.refreshControl endRefresh];
        // 刷新表格
        [self.tableView reloadData];
    });
}



// 下拉刷新动画 (展示更新多少条微博数据)
- (void)pullDownAnimationWithStatusCounts:(NSInteger)counts {
    
    if (self.pullDownStatusCountsLabel.superview) {
        return;
    }
    
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
- (void)pullUpAnimationWithRequestFaild {
    
    if (self.pullDownStatusCountsLabel.superview) {
        return;
    }
    
    if (self.pullDownStatusCountsLabel.superview == nil) {
        
        self.pullDownStatusCountsLabel.text = @"上拉刷新多次数据为零,请稍后再试";
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
    
#pragma mark - url 点击跳转
    __weak typeof(self) weakSelf = self;
    [cell setUrlTextCompeletionHandler:^(NSString *text) {
        SFSafariViewController *sfViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:text]];
        [weakSelf presentViewController:sfViewController animated:YES completion:nil];
    }];
    [cell setRetweetUrlTextCompeletionHandler:^(NSString *text) {
        SFSafariViewController *sfViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:text]];
        [weakSelf presentViewController:sfViewController animated:YES completion:nil];
    }];
    
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
