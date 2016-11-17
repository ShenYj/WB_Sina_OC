//
//  JSHomeNavButton.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/28.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSHomeNavButton : UIButton

// 自定义构造函数
- (instancetype)initWithName:(NSString *)name;
// 自定义构造函数
- (instancetype)initWithTitleName:(NSString *)titleName withAction:(SEL)selector withTarget:(id)target;

/** button点击回调 */
@property (nonatomic,copy) void (^clickHandler)();


@end
