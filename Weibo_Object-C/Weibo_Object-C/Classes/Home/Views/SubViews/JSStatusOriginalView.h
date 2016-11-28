//
//  JSStatusOriginalView.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JSHomeStatusModel;

@interface JSStatusOriginalView : UIView

@property (nonatomic) JSHomeStatusModel *statusData;

@property (nonatomic,copy) void (^urlTextCompeletionHandler)(NSString *text);

@end
