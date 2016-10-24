//
//  JSHomeStatusLayout.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/24.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSHomeStatusLayout : NSObject


@property (nonatomic,assign) CGFloat HomeStatusLayoutMargin;                         // 间距
@property (nonatomic,assign) CGFloat HomeStatusLayoutHeadImageViewSize;              // 用户头像Size(宽高)
@property (nonatomic,assign) CGFloat HomeStatusLayoutUserStatusImageViewSize;        // 用户等级图片Size(宽高)
@property (nonatomic,assign) CGFloat HomeStatusLayoutContentLabelFontSize;           // 原创微博内容字体大小
@property (nonatomic,assign) CGFloat HomeStatusLayoutRetweetContentLabelFontSize;    // 转发微博内容字体大小
@property (nonatomic,assign) CGFloat HomeStatusLayoutToolBarHeight;                  // 底部工具栏高度
@property (nonatomic,assign) CGFloat HomeStatusLayoutToolBarBottomMargin;            // 底部工具栏距离Cell的contentView底部间距
@property (nonatomic,assign) CGFloat HomeStatusLayoutPictureViewItemMargin;          // 配图视图中每个Item间的间距
@property (nonatomic,assign) CGFloat HomeStatusLayoutPictureViewItemSizeWH;          // 配图视图每个Item的Size
@property (nonatomic,assign) CGSize  HomeStatusLayoutPictureViewSize;                // 配图视图的Size
@property (nonatomic,assign) CGSize  HomeStatusLayoutPictureViewMaxSize;             // 配图视图的最大Size


@end
