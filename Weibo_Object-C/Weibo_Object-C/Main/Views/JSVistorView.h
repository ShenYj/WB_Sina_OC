//
//  JSVistorView.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/26.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSVistorView : UIView

@property (nonatomic,copy) void(^finishedBlock)();
//设置访客视图信息
- (void)setupVistorViewInfoWithTitle:(NSString *)title withImageName:(NSString *)imageName;

@end
