//
//  JSEmoticonToolBarButton.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EmoticonToolBarButtonType) {
    EmoticonToolBarButtonTypeDefault     = 1100,
    EmoticonToolBarButtonTypeEmoji       = 1101,
    EmoticonToolBarButtonTypeLangxiaohua = 1102
};

@interface JSEmoticonToolBarButton : UIButton



// 表情键盘按钮类型
@property (assign,nonatomic) EmoticonToolBarButtonType toolBarButtonType;


// 自定义构造函数
+ (instancetype)creatToolBarButtonWithTitile:(NSString *)title withImageName:(NSString *)imageName withButtonType:(EmoticonToolBarButtonType)type;



@end
