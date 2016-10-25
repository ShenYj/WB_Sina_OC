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
#import "JSNetworkTool.h"
#import "JSHomeStatusModel.h"
#import "JSStatusCell.h"

static NSString * const homeTableCellReusedId = @"homeTableCellReusedId";

@interface JSHomeTableViewController ()

// 当前登录用户及其所关注（授权）用户的最新微博数据
@property (nonatomic) NSArray <JSHomeStatusModel *> *homeStatusDatas;

// 上拉刷新指示控件
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation JSHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isLogin) {
        
        [self.vistorView setupVistorViewInfoWithTitle:nil withImageName:nil];
    } else {
        
        [self prepareView];
    }
    
}

- (void)prepareView {
    // 使用Status模型类记录行高
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 200.f;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = self.activityIndicatorView;
    
    // 首次展示首页请求数据
    [self loadHomeStatusDataByIsPulling:self.activityIndicatorView.isAnimating];

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
    
    NSInteger sinceId = 0;
    NSInteger maxId = 0;
    
    if (self.activityIndicatorView.isAnimating) {
        
        // 停止动画
        [self.activityIndicatorView stopAnimating];
        
        // 上拉加载更多
        maxId += self.homeStatusDatas.lastObject.wb_id.integerValue;
        
        if (maxId > 0) {
            // 上拉加载更多,返回ID小于或等于max_id的微博
            maxId -= 1;
        }
        
        
    } else {
        //  下拉刷新
        sinceId += self.homeStatusDatas.firstObject.wb_id.integerValue;
        
    }
    
    NSLog(@"sinceId: %zd,maxId:%zd",sinceId,maxId);
    
    [[JSNetworkTool sharedNetworkTool] loadHomePublicDatawithFinishedBlock:^(id obj, NSError *error) {
        
        NSArray *statusDataArr = (NSArray *)obj;
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        for (NSDictionary *dict in statusDataArr) {
            
            JSHomeStatusModel *model = [JSHomeStatusModel statuWithDict:dict];
            [mArr addObject:model];
            
        }
        
        self.homeStatusDatas = [self.homeStatusDatas arrayByAddingObjectsFromArray:mArr];
        
        [self.tableView reloadData];
        
    } Since_id:sinceId max_id:maxId];
    
    
}

#pragma mark
#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.homeStatusDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JSHomeStatusModel *dataModel = self.homeStatusDatas[indexPath.row];
    
    JSStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:homeTableCellReusedId];
    
    if ( !cell ) {
        cell = [[JSStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeTableCellReusedId];
    }
    
    cell.statusData = dataModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

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
- (NSArray<JSHomeStatusModel *> *)homeStatusDatas {
    
    if (_homeStatusDatas == nil) {
        _homeStatusDatas = [NSArray array];
    }
    return _homeStatusDatas;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.color = THEME_COLOR;
    }
    return _activityIndicatorView;
}


@end
