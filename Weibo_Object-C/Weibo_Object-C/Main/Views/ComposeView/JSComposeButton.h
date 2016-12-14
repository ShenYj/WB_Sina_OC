//
//  JSComposeButton.h
//  ComposeView
//
//  Created by ShenYj on 2016/12/9.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSComposeButton : UIControl

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

/** 展示的控制器类名 */
@property (nonatomic,copy) NSString *clsName;

@end
