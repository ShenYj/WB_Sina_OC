//
//  JSMessageViewController.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSMessageViewController.h"
#import "JSNetworkTool+JSExtension.h"
#import "JSNetworkTool+JSUnreadExtension.h"
#import "JSUserAccountTool.h"

@interface JSMessageViewController ()

@end

@implementation JSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[JSNetworkTool sharedNetworkTool] loadHomeStatusCompeletionHandler:^(NSArray *datas, BOOL isSuccess) {
       
        if (!isSuccess) {
            NSLog(@"请求失败");
            return ;
        }
        
    }];
    
}

- (void)loadDataWithIsPulling:(BOOL)isPulling {
    
}

- (void)prepareTableView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
