//
//  JSFlowLayout.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSFlowLayout.h"
#import "JSHomeStatusModel.h"

// 引用JSHomeStatusModel中的 kItemMargin全局变量
extern CGFloat kMargin;
extern CGFloat kItemMargin;

@implementation JSFlowLayout 

- (void)prepareLayout {
    
    // 每张配图(Cell) 的尺寸 (等高等宽)
    CGFloat itemSizeWH = ([UIScreen mainScreen].bounds.size.width - 2 * kMargin - 2 * kItemMargin) / 3;
    self.itemSize = CGSizeMake(itemSizeWH, itemSizeWH);
    self.minimumLineSpacing = kItemMargin;
    self.minimumInteritemSpacing = kItemMargin;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
}

@end
