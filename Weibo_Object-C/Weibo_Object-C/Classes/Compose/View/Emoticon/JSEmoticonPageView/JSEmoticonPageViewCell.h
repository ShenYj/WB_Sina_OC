//
//  JSEmoticonPageViewCell.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSEmoticonModel;

@interface JSEmoticonPageViewCell : UICollectionViewCell

// 表情一维数组
@property (nonatomic) NSArray <JSEmoticonModel *>*emoticons;
// 展示label
@property (nonatomic) UILabel *detail;

@end
