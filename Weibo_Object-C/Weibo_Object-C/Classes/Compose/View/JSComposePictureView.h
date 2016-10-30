//
//  JSComposePictureView.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/29.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSComposePictureView : UICollectionView


/**
 添加图片的回调
 */
@property (nonatomic,copy) void(^inserImageHandler)();

/**
 像图片视图添加图片
 */
- (void)insertImage:(UIImage *)image;

@end
