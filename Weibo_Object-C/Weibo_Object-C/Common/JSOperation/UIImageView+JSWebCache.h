//
//  UIImageView+JSWebCache.h
//  SyncDownLoadImg
//
//  Created by ShenYj on 16/8/25.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDownLoadOperationManager.h"

@interface UIImageView (JSWebCache)

/**
 UIImageView设置图片静态方法

 @param urlString        图片URL地址字符串
 @param placeHolderImage 占位图片
 */
- (void)js_imageUrlString: (NSString *)urlString
     withPlaceHolderImage: (NSString *)placeHolderImage;

/**
 UIImageView高性能绘制圆角图片
 
 @param urlString        图片URL地址字符串
 @param size             图片尺寸
 @param fillColor        圆角图片外围填充色
 @param completion       完成回调
 */
- (void)js_imageUrlString: (NSString *)urlString
                 WithSize: (CGSize)size
               fillClolor: (UIColor *)fillColor
               completion: (void(^)(UIImage *img))completion;


/**
 UIImageView高性能绘制圆角图片+ 占位图片

 @param urlString        图片URL地址字符串
 @param placeHolderImage 占位图片URL地址字符串
 @param size             图片尺寸
 @param fillColor        圆角图片外围填充色
 @param completion       完成回调
 */
- (void)js_imageUrlString: (NSString *)urlString
     withPlaceHolderImage: (NSString *)placeHolderImage
                 WithSize: (CGSize)size
               fillClolor:(UIColor *)fillColor
               completion: (void(^)(UIImage *img))completion;

/**
  UIImageView高性能绘制圆角图片+ 占位图片
 @param imageURL         图片URL地址字符串
 @param placeHolderImage 占位图片URL地址字符串
 @param size             图片尺寸
 @param fillColor        圆角图片外围填充色
 */
- (void)js_setImageWithURL: (NSString *)imageURLString
               placeholder: (UIImage *)placeholderImage
              expectedSize: (CGSize)size
                 fillColor: (UIColor *)fillColor;


/**
 UIImageView高性能绘制圆角图片+ 占位图片 (不带圆角)
 @param imageURL         图片URL地址字符串
 @param placeHolderImage 占位图片URL地址字符串
 @param size             图片尺寸
 @param fillColor        圆角图片外围填充色
 */
- (void)js_setImagewithOutCornerRadiusWithURL: (NSString *)imageURLString
               placeholder: (UIImage *)placeholderImage
              expectedSize: (CGSize)size
                 fillColor: (UIColor *)fillColor;

@end
