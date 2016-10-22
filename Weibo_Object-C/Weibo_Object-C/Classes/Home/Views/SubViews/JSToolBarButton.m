//
//  JSToolBarButton.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSToolBarButton.h"

@implementation JSToolBarButton
/**
  imageNames[0],正常状态下按钮图片名称
  imageNames[1],高亮状态下按钮图片名称
 */
- (instancetype)initWithImageNames:(NSArray <NSString * >*)imageNames {
    self = [super init];
    if (self) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imageNames[0]] forState:UIControlStateNormal];
        if (imageNames.count > 1) {
            [self setImage:[UIImage imageNamed:imageNames[1]] forState:UIControlStateHighlighted];
        }
        [self setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
        [self addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



- (void)clickToolBarButton:(JSToolBarButton *)toolBarButton {
    
    
    switch (toolBarButton.toolBarButtonType) {
            
        case JSToolBarButtonTypeRetweeted:
            NSLog(@"JSToolBarButtonTypeRetweeted");
            break;
        case JSToolBarButtonTypeComment:
            NSLog(@"JSToolBarButtonTypeComment");
            break;
        case JSToolBarButtonTypeLike:
            NSLog(@"JSToolBarButtonTypeLike");
            break;
        default:
            break;
    }
    
    
}

@end
