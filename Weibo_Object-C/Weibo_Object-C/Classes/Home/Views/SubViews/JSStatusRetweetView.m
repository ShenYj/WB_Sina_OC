//
//  JSStatusRetweetView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusRetweetView.h"

@implementation JSStatusRetweetView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    
    self.backgroundColor = [UIColor js_randomColor];
    
}

@end
