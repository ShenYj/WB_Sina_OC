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
// 引用JSHomeStatusModel中的itemSizeWH (图片Item)的宽高
extern CGFloat itemSizeWH;


@implementation JSFlowLayout

- (void)prepareLayout {
    
    self.itemSize = CGSizeMake(itemSizeWH, itemSizeWH);
    self.minimumLineSpacing = kItemMargin;
    self.minimumInteritemSpacing = kItemMargin;
    //self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
}

@end
