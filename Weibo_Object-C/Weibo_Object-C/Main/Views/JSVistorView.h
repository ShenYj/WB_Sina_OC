//
//  JSVistorView.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/26.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSVistorView : UIView

// 访客视图参数
@property (nonatomic,strong) NSDictionary *userInfo;

// 访客视图注册/登录按钮点击回调
@property (nonatomic,copy) void(^finishedBlock)();


@end
