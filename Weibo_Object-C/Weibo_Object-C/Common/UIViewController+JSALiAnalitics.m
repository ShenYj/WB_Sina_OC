//
//  UIViewController+JSALiAnalitics.m
//  Weibo_Object-C
//
//  Created by ecg on 2018/8/7.
//  Copyright © 2018年 ___ShenYJ___. All rights reserved.
//

#import "UIViewController+JSALiAnalitics.h"

@implementation UIViewController (JSALiAnalitics)

+ (void)load {
//    NSString *className = NSStringFromClass(self.class);
//    NSLog(@"%@", className);
//    [self replaceOrExchangeMethodOriginSelector:@selector(viewDidAppear:) SwizzledSelector:@selector(my_viewDidAppear:)];
//    [self replaceOrExchangeMethodOriginSelector:@selector(viewDidDisappear:) SwizzledSelector:@selector(my_viewDidDisappear:)];
}

- (void)my_viewDidAppear:(BOOL)animated {
    [[ALBBMANPageHitHelper getInstance] pageAppear:self];
    NSString *className = NSStringFromClass(self.class);
    NSDictionary *dict = [NSDictionary dictionaryWithObject:className forKey:className];
    [[ALBBMANPageHitHelper getInstance] updatePageProperties:self properties:dict];
    [self my_viewDidAppear:animated];
}

- (void)my_viewDidDisappear:(BOOL)animated {
    // 事件埋点
    [[ALBBMANPageHitHelper getInstance] pageDisAppear:self];
    // 删除全局字段
    [[[ALBBMANAnalytics getInstance] getDefaultTracker] removeGlobalProperty:@"loadDataWithIsPulling"];
    [self my_viewDidDisappear:animated];
}

+ (void)replaceOrExchangeMethodOriginSelector:(SEL)originSelector
                             SwizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class,originSelector);
    Method swizzledMethod = class_getInstanceMethod(class,swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) { class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
