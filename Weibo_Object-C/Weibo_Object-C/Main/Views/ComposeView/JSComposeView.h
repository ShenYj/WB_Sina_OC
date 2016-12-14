//
//  JSComposeView.h
//  ComposeView
//
//  Created by ShenYj on 2016/12/8.
//  Copyright © 2016年 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSComposeView : UIView

/** 展示编辑视图,供外界调用 */
- (void)showComposeViewWithCompeletionHandler:(void (^)(NSString *clsName))compeletionHandler;

@end
