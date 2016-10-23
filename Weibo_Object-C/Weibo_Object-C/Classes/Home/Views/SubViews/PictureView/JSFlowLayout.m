//
//  JSFlowLayout.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSFlowLayout.h"

@implementation JSFlowLayout

- (void)prepareLayout {
    
    self.itemSize = CGSizeMake(100, 100);
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end
