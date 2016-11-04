//
//  JSEmoticonPageViewFlowLayout.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonPageViewFlowLayout.h"

extern CGFloat const kEmoticonToolBarHeight;              // 表情键盘底部Toolbar高度
extern CGFloat const kEmoticonPageViewHorizontalMargin;   // 表情键盘左右两侧间距
extern CGFloat const kEmoticonPageViewBottomMargin;       // 表情键盘表情区域底部间距

@implementation JSEmoticonPageViewFlowLayout

- (void)prepareLayout {
    /*
        216 表情键盘的高度(PageView + 底部ToolBar)
        37 底部ToolBar的高度
     */
    self.itemSize = CGSizeMake(SCREEN_WIDTH - kEmoticonPageViewHorizontalMargin*2, 216 - kEmoticonToolBarHeight - kEmoticonPageViewBottomMargin);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
}

@end
