//
//  JSPictureViewCell.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAnimatedImageView.h"

@class JSHomeStatusPictureModel;

@interface JSPictureViewCell : UICollectionViewCell

@property (nonatomic) JSHomeStatusPictureModel *pictureModel;

@property (nonatomic) YYAnimatedImageView *pictureImageView;

@end
