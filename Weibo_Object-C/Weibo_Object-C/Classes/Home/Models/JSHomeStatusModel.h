//
//  JSHomeStatusModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSHomeStatusModel;
@class JSHomeStatusUserModel;
@class JSHomeStatusPictureModel;
@class JSHomeStatusLayout;


// 首页布局信息
typedef struct {
    
    CGFloat HomeStatusLayoutTopMargin;                      // 顶部间距
    CGFloat HomeStatusLayoutMargin;                         // 间距(子视图)
    CGFloat HomeStatusLayoutHeadImageViewSize;              // 用户头像Size(宽高)
    CGFloat HomeStatusLayoutUserStatusImageViewSize;        // 用户等级图片Size(宽高)
    CGFloat HomeStatusLayoutContentLabelFontSize;           // 原创微博内容字体大小
    CGFloat HomeStatusLayoutRetweetContentLabelFontSize;    // 转发微博内容字体大小
    CGFloat HomeStatusLayoutToolBarHeight;                  // 底部工具栏高度
    CGFloat HomeStatusLayoutToolBarBottomMargin;            // 底部工具栏距离Cell的contentView底部间距
    CGFloat HomeStatusLayoutPictureViewItemMargin;          // 配图视图中每个Item间的间距
    CGSize  HomeStatusLayoutPictureViewSize;                // 配图视图的Size
    CGSize  HomeStatusLayoutPictureViewItemSize;            // 配图视图中每个Item的Size
    CGSize  HomeStatusLayoutPictureViewMaxSize;             // 配图视图的最大Size
    
} HomeStatusLayout;

@interface JSHomeStatusModel : NSObject


#pragma mark
#pragma mark - properties
// 微博创建时间
@property (nonatomic,copy) NSString *created_at;
// 微博ID
@property (nonatomic) NSNumber *wb_id;
// 微博信息内容
@property (nonatomic,copy) NSString *text;
// 微博来源
@property (nonatomic,copy) NSString *source;
// 微博作者的用户信息字段
@property (nonatomic) JSHomeStatusUserModel *user;
// 转发微博
@property (nonatomic) JSHomeStatusModel *retweeted_status;
// 转发数
@property (nonatomic) NSNumber *reposts_count;
// 评论数
@property (nonatomic) NSNumber *comments_count;
// 表态数
@property (nonatomic) NSNumber *attitudes_count;
// 配图
@property (nonatomic) NSArray <JSHomeStatusPictureModel *>*pic_urls;



#pragma mark - extension
// (底部ToolBar的数据,将数值类型转换成字符串并保存起来)
@property (nonatomic,copy) NSString *reposts_count_string;
@property (nonatomic,copy) NSString *comments_count_string;
@property (nonatomic,copy) NSString *attitudes_count_string;

// (配图视图的Size)
@property (nonatomic,assign) CGSize pictureViewSize;

// (微博来源,处理后)
@property (nonatomic,copy) NSMutableAttributedString *sourceString;

// (微博发布时间显示格式)
@property (nonatomic,copy) NSString *created_at_formatterString;

// 记录行高1 (模型类)
@property (nonatomic,assign) CGFloat homeStatusRowHeigh;
@property (nonatomic,strong) JSHomeStatusLayout *homeStatusLayout;
// 记录行高2 (解耦固体)
@property (nonatomic,assign) CGFloat homeStatusRowHeightStruct;
@property (nonatomic,assign) HomeStatusLayout homeStatusLayoutStruct;



#pragma mark
#pragma mark - methods
// 静态方法
+ (instancetype)statuWithDict:(NSDictionary *)dict;
// 实例方法
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
