//
//  JSPictureViewFlowLayout.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/29.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSPictureViewFlowLayout.h"

extern CGFloat const kPictureMarginHorizontal;      // 配图视图距离父视图的左右间距
static CGFloat const kItemsMargin = 5.f;            // item之间的间距
static NSInteger const kItemsRowMaxTotalCount = 3;  // 每行items最大个数
CGFloat itemSize;                                   // Item的Size

@implementation JSPictureViewFlowLayout

+ (void)initialize {
    
    // 计算item的平均Size(宽,高)
    itemSize = (SCREEN_WIDTH - (kItemsRowMaxTotalCount-1)*kItemsMargin - 2*kPictureMarginHorizontal) / kItemsRowMaxTotalCount;
}

- (void)prepareLayout {
    
    //CGFloat width = (self.collectionView.bounds.size.width - (kItemsRowMaxTotalCount + 1) * kItemsMargin) / kItemsRowMaxTotalCount;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = CGSizeMake(itemSize, itemSize);
    self.minimumLineSpacing = kItemsMargin;
    self.minimumInteritemSpacing = kItemsMargin;
        
}

@end
