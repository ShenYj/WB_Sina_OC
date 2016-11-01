//
//  JSComposeToolBar.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSComposeToolBarButton.h"


@interface JSComposeToolBar : UIView

// 判断是否是表情键盘的标识
@property (assign,nonatomic,getter=isEmoticon) BOOL emoticon;
// 完成回调
@property (copy,nonatomic) void(^completionHandler)(JSComposeToolBarButton *ToolBarButton);

@end
