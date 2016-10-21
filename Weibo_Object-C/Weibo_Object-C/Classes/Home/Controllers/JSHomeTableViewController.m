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

static NSString * const homeTableCellReusedId = @"homeTableCellReusedId";

@interface JSHomeTableViewController ()

// 当前登录用户及其所关注（授权）用户的最新微博数据
@property (nonatomic) NSArray <JSHomeStatusModel *> *homeStatusDatas;

@end

@implementation JSHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isLogin) {
        
        [self prepareView];
        
    } else {
        
        [self.vistorView setupVistorViewInfoWithTitle:nil withImageName:nil];
    }
}

- (void)prepareView {
    
    self.view.backgroundColor = [UIColor js_randomColor];
    
    [self loadHomeStatusData:^(NSArray<JSHomeStatusModel *> *datas) {
       
        self.homeStatusDatas = datas;
        [self.tableView reloadData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - loadHomeStatusData

- (void)loadHomeStatusData:(void (^)(NSArray <JSHomeStatusModel *>*datas))completionHandler {
    

    [[JSNetworkTool sharedNetworkTool] loadHomePublicDatawithFinishedBlock:^(id obj, NSError *error) {
        
        NSArray *statusDataArr = (NSArray *)obj;
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        for (NSDictionary *dict in statusDataArr) {
            
            JSHomeStatusModel *model = [JSHomeStatusModel statuWithDict:dict];
            NSLog(@"%@",model.description);
            [mArr addObject:model];
        }
        
        completionHandler(mArr.copy);
    }];
}

#pragma mark
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.homeStatusDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeTableCellReusedId];
    
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeTableCellReusedId];
    }
    
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}

#pragma mark
#pragma mark - lazy



@end
