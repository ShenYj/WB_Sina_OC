//
//  JSToolBarButton.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/22.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

// ToolBar按钮功能
typedef NS_ENUM(NSUInteger, JSToolBarButtonType) {
    JSToolBarButtonTypeRetweeted,
    JSToolBarButtonTypeComment,
    JSToolBarButtonTypeLike
};

@interface JSToolBarButton : UIButton

/**
 imageNames[0],正常状态下按钮图片名称
 imageNames[1],选中状态下按钮图片名称
 */
- (instancetype)initWithImageNames:(NSArray <NSString * >*)imageNames;

// 按钮类型
@property (nonatomic,assign) JSToolBarButtonType toolBarButtonType;



@end
