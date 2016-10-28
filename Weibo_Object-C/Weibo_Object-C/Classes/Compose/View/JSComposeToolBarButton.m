//
//  JSComposeToolBarButton.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposeToolBarButton.h"

@implementation JSComposeToolBarButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareView];
    }
    return self;
}

/**
    准备视图
 */
- (void)prepareView {
    
    [self setBackgroundImage:[UIImage imageNamed:@"compose_toolbar_background"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"compose_toolbar_background"] forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
}

/**
     button点击事件
 */
- (void)clickToolBarButton:(JSComposeToolBarButton *)sender {
    
    switch (sender.toolBarButtonType) {
        case JSComposeToolBarTypePicture:
            NSLog(@"JSComposeToolBarTypePicture");
            break;
        case JSComposeToolBarTypeMention:
            NSLog(@"JSComposeToolBarTypeMention");
            break;
        case JSComposeToolBarTypeTrend:
            NSLog(@"JSComposeToolBarTypeTrend");
            break;
        case JSComposeToolBarTypeEmoticon:
            NSLog(@"JSComposeToolBarTypeEmoticon");
            break;
        case JSComposeToolBarTypeAdd:
            NSLog(@"JSComposeToolBarTypeAdd");
            break;
            
        default:
            break;
    }
}

@end
