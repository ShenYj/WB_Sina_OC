//
//  JSComposeToolBarButton.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JSComposeToolBarType) {
    JSComposeToolBarTypePicture = 1001,
    JSComposeToolBarTypeMention = 1002,
    JSComposeToolBarTypeTrend = 1003,
    JSComposeToolBarTypeEmoticon = 1004,
    JSComposeToolBarTypeAdd = 1005
};

@interface JSComposeToolBarButton : UIButton

@property (assign,nonatomic) JSComposeToolBarType toolBarButtonType;

@end
