//
//  JSComposePictureViewCell.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/29.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSComposePictureViewCell : UICollectionViewCell

// 删除按钮回调
@property (nonatomic,copy) void(^deleteImageHandler)();
// 图片
@property (nonatomic) UIImage *pictureImage;


@end
