//
//  JSPictureView.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSHomeStatusModel;
@class JSHomeStatusPictureModel;

@interface JSPictureView : UICollectionView

//@property (nonatomic) JSHomeStatusModel *statusData;

@property (nonatomic) NSArray <JSHomeStatusPictureModel *>*pictures;

@end
