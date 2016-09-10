//
//  JSProfileTableViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSProfileTableViewController.h"
#import "JSVistorView.h"

@interface JSProfileTableViewController ()

@end

@implementation JSProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isLogin) {
        [self.vistorView setupVistorViewInfoWithTitle:@"登录后，你的微博、相册、个人资料会显示在这里，展示给别人" withImageName:@"visitordiscover_image_profile"];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


@end
