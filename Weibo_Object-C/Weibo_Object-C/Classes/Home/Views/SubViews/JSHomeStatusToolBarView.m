//
//  JSHomeStatusToolBarView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeStatusToolBarView.h"

@interface JSHomeStatusToolBarView ()


@end

@implementation JSHomeStatusToolBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

#pragma mark 
#pragma mark - set up UI

- (void)prepareView {
    
    self.backgroundColor = [UIColor redColor];
}

#pragma mark 
#pragma mark - lazy


@end
