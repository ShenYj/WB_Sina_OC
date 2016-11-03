//
//  JSEmoticonToolBar.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSEmoticonToolBarButton;

@interface JSEmoticonToolBar : UIStackView

// 点击按钮回调
@property (copy,nonatomic) void(^clickCompeletionHandler)(JSEmoticonToolBarButton *button);

// 设置当前选中按钮
- (void)setCurrentButtonIndex:(NSInteger)index;

@end
