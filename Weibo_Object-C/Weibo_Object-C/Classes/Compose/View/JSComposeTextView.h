//
//  JSComposeTextView.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSComposeTextView : UITextView

/**
 占位文字
 */
@property (nonatomic,copy) NSString *placeholder;

/**
 显示隐藏标识
 */
@property (nonatomic,assign) BOOL placeholderHidden;



@end
