//
//  JSNavigationBar.m
//  Weibo_Object-C
//
//  Created by ecg on 2018/8/6.
//  Copyright © 2018年 ___ShenYJ___. All rights reserved.
//

#import "JSNavigationBar.h"

@implementation JSNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    for (UIView *view in self.subviews) {
        if (systemVersion >= 11.0) {
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                //NSLog(@"_UIBarBackground");
                CGRect frame = view.frame;
                frame.size.height = 64;
                if (IS_IPHONE_X) {
                    frame.origin.y = 24;
                }
                view.frame = frame;
                //NSLog(@"修改后的Frame: %@",NSStringFromCGRect(view.frame));
            }
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                //NSLog(@"_UINavigationBarContentView");
                CGRect frame = view.frame;
                frame.origin.y = 20;
                if (IS_IPHONE_X) {
                    frame.origin.y = 44;
                }
                view.frame = frame;
            }
        }
    }
}

@end
