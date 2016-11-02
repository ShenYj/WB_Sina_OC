//
//  JSEmoticonPageViewFlowLayout.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonPageViewFlowLayout.h"

@implementation JSEmoticonPageViewFlowLayout

- (void)prepareLayout {
    /*
        216 表情键盘的高度(PageView + 底部ToolBar)
        37 底部ToolBar的高度
     */
    self.itemSize = CGSizeMake(SCREEN_WIDTH, 216 - 37);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
}

@end
