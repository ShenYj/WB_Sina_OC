//
//  JSEmoticonPageView.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSEmoticonPageView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>

// 滚动表情键盘回调
@property (copy,nonatomic) void (^scrollCompeletionHandler)(NSInteger section);

@end
