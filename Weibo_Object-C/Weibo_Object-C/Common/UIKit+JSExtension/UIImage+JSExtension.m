//
//  UIImage+JSExtension.m
//  HeaderViewScaleByDragging
//
//  Created by ShenYj on 16/8/17.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "UIImage+JSExtension.h"
#import <ImageIO/ImageIO.h>


@implementation UIImage (Color)

// 根据传入Size重新生成图片(优化后)
- (void)js_ImageWithSize:(CGSize)size completion:(void(^)(UIImage *img))completion{
    
    // 异步处理
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
        
        // 设置rect
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        // 将原始图片绘制到图形上下文中
        [self drawInRect:rect];
        
        // 从图形上下获取图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭图形上下文
        UIGraphicsEndImageContext();
        
        // 主线程返回圆形图片
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(image);
            }
        });
        
    });
    
}

// 生成圆角图片(优化后)
- (void)js_cornerImageWithSize:(CGSize)size fillClolor:(UIColor *)fillColor completion:(void(^)(UIImage *img))completion{
    
    // 异步处理
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //CGRect rect = CGRectMake(0, 0, size.width < self.size.width ? size.width : self.size.width, size.height < self.size.height ? size.height : self.size.height);
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
        // 设置rect
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 设置填充色
        [fillColor set];
        UIRectFill(rect);
        // 计算半径
        CGFloat cornerRadius = MIN(size.width, size.height) * 0.5;
        // 设置圆形路径并切割
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
        // 将原始图片绘制到图形上下文中
        [self drawInRect:rect];
        // 从图形上下获取图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭图形上下文
        UIGraphicsEndImageContext();
        // 主线程返回圆形图片
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(image);
            }
        });
        
    });
    
}




// 生成纯色图片
+ (UIImage *)js_createImageWithColor:(UIColor *)color withSize:(CGSize)imageSize{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// 生成圆角图片
+ (UIImage *)js_imageWithOriginalImage:(UIImage *)originalImage{
    
    CGRect rect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    
    CGFloat cornerRadius = MIN(originalImage.size.width, originalImage.size.height) * 0.5;
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    
    [originalImage drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// 生成纯色圆角图片
+ (UIImage *)js_createRoundedImageWithColor:(UIColor *)color withSize:(CGSize)imageSize{
    
    UIImage *originalImage = [self js_createImageWithColor:color withSize:imageSize];
    
    return [self js_imageWithOriginalImage:originalImage];
}

// 生成带圆环的圆角图片
+ (UIImage *)js_imageWithOriginalImage:(UIImage *)originalImage withBorderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth{
    
    CGRect rect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    
    CGFloat cornerRadius = MIN(originalImage.size.width, originalImage.size.height) * 0.5;
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    
    [originalImage drawInRect:rect];
    
    CGPoint center = CGPointMake(originalImage.size.width * 0.5, originalImage.size.height * 0.5);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:cornerRadius - borderWidth*0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    circlePath.lineWidth = borderWidth;
    
    [borderColor setStroke];
    
    [circlePath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
    
}



/** SDWebImage源码 使用了ImageIO的函数*/
+ (UIImage *)js_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    // 取出gif动图的帧数
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    // 判断图片数量,如果为1,直接返回静态图像
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else { // 创建图像数组
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            // 取出第i帧
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            // 累加时长
            duration += [self js_frameDurationAtIndex:i source:source];
            // 添加到图像数组中
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        // 设置动图数组
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }

    CFRelease(source);
    
    return animatedImage;
}


+ (float)js_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}



@end
