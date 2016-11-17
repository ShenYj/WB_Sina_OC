//
//  JSHomeNavButton.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeNavButton.h"

@implementation JSHomeNavButton

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",name]] forState:UIControlStateHighlighted];
        [self sizeToFit];
        [self addTarget:self action:@selector(clickNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (instancetype)initWithTitleName:(NSString *)titleName withAction:(SEL)selector withTarget:(id)target {
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitle:titleName forState:UIControlStateNormal];
        [self setTitle:titleName forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [self sizeToFit];
    }
    return self;
}

// 按钮点击事件
- (void)clickNavigationBarButton:(JSHomeNavButton *)barButtonItem {
    
    if (self.clickHandler) {
        self.clickHandler();
    }
    
}

@end
