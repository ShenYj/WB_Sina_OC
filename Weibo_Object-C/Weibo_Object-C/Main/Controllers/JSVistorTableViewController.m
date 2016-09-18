//
//  JSVistorTableViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/26.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSVistorTableViewController.h"
#import "JSVistorView.h"
#import "JSNavigationController.h"
#import "JSOAuthorizeViewController.h"
#import "JSUserAccountTool.h"

@interface JSVistorTableViewController ()

@end

@implementation JSVistorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航按钮
    [self setNavButton];
    
}



- (void)loadView{
    
    if ( [JSUserAccountTool sharedManager].isLogin ) {
        // 已登录
        [super loadView];
        
    }else{
        // 未登录
        __weak typeof(self) weakSelf = self;
        self.vistorView = [[JSVistorView alloc]init];
        [self.vistorView setFinishedBlock:^{
           
            [weakSelf buttonClick:nil];
            
        }];
        self.view = self.vistorView;
        
    }
}


- (void)setNavButton{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick:)];
}

- (void)buttonClick:(UIBarButtonItem *)sender{
    
    JSOAuthorizeViewController *webVC = [[JSOAuthorizeViewController alloc]init];
    JSNavigationController *naVc = [[JSNavigationController alloc]initWithRootViewController:webVC];
    
    [self presentViewController:naVc animated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}



@end
