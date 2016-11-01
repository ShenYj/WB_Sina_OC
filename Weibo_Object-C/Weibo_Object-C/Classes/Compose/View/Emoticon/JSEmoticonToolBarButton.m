//
//  JSEmoticonToolBarButton.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonToolBarButton.h"



@implementation JSEmoticonToolBarButton


+ (instancetype)creatToolBarButtonWithTitile:(NSString *)title withImageName:(NSString *)imageName withButtonType:(EmoticonToolBarButtonType)type {
    
    JSEmoticonToolBarButton *button = [[self alloc] init];
    button.toolBarButtonType = type;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"compose_emotion_table_%@_normal",imageName]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"compose_emotion_table_%@_selected",imageName]] forState:UIControlStateSelected];
    
    return button;
    
}




@end
