
//
//  JSHomeStatusModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeStatusModel.h"
#import "JSHomeStatusUserModel.h"
#import "JSHomeStatusPictureModel.h"

// 配图视图的参数 配图视图距离屏幕两个的间距和配图间的间距
CGFloat const kMargin = 10.f;
CGFloat const kItemMargin = 5.f;


@implementation JSHomeStatusModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)statuWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.wb_id = value;
        
    } else if ([key isEqualToString:@"user"]) {
        
        NSDictionary *dict = (NSDictionary *)value;
        
        JSHomeStatusUserModel *userModel = [JSHomeStatusUserModel modelWithDict:dict];
        // 用户模型赋值
        self.user = userModel;
        
    } else if ([key isEqualToString:@"retweeted_status"]) {
        
        NSDictionary *dict = (NSDictionary *)value;
        
        JSHomeStatusModel *retweeted_status = [JSHomeStatusModel statuWithDict:dict];
        // 转发微博模型赋值
        self.retweeted_status = retweeted_status;
        
    } else if ([key isEqualToString:@"pic_urls"]) {
        
        NSArray *pic_urls = (NSArray *)value;
        
        if (pic_urls.count > 0) {
            
            NSMutableArray *mArr = [NSMutableArray array];
            
            for (NSDictionary *dict in pic_urls) {
                
                JSHomeStatusPictureModel *thumbnail_pic_Model = [JSHomeStatusPictureModel picWithDict:dict];
                
                [mArr addObject:thumbnail_pic_Model];
            }
            
            self.pic_urls = mArr.copy;
            
        }
        
    }else {
        // KVC字典转模型
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

#pragma mark - 重写转发评论在属性的set方法,给自定义属性赋值
- (void)setReposts_count:(NSNumber *)reposts_count {
    
    _reposts_count = reposts_count;
    
    self.reposts_count_string = [self transformDisplayContentByNSNumber:reposts_count withTitle:@"转发"];
}

- (void)setComments_count:(NSNumber *)comments_count {
    
    _comments_count = comments_count;
    
    self.comments_count_string = [self transformDisplayContentByNSNumber:comments_count withTitle:@"评论"];
}

- (void)setAttitudes_count:(NSNumber *)attitudes_count {
    
    _attitudes_count = attitudes_count;
    
    self.attitudes_count_string = [self transformDisplayContentByNSNumber:attitudes_count withTitle:@"赞"];
    
}

- (void)setPic_urls:(NSArray<JSHomeStatusPictureModel *> *)pic_urls {
    
    _pic_urls = pic_urls;
    
    self.pictureItemSize = [self getPictureViewSizeWithItemCounts:pic_urls.count];
    
}

- (void)setSource:(NSString *)source {
    
    _source = source;
    
    self.sourceString = [self getStatusScourceStringWithOriginalInfo:source];
    
}

// 根据配图的个数,计算配图视图的宽度和高度
- (CGSize)getPictureViewSizeWithItemCounts:(NSInteger)itemCount {
    
    // 每张配图(Cell) 的尺寸 (等高等宽)
    CGFloat itemSizeWH = ([UIScreen mainScreen].bounds.size.width - 2 * kMargin - 2 * kItemMargin) / 3;
    
    // 计算行数和列数
    NSInteger col = (itemCount == 4) ? 2 : ((itemCount >= 3) ? 3 : itemCount);
    NSInteger row = (itemCount == 4) ? 2 : ((itemCount - 1) / 3 + 1);
    
    // 计算PictureView的宽度和高度
    CGFloat pictureViewSizeW = col * itemSizeWH + (col - 1) * kItemMargin;
    CGFloat pictureViewSizeH = row * itemSizeWH + (col - 1) * kItemMargin;
    
    return CGSizeMake(pictureViewSizeW, pictureViewSizeH);
}

#pragma mark - 获取微博来源字符串
- (NSMutableAttributedString *)getStatusScourceStringWithOriginalInfo:(NSString *)originalInfo {
    
    // <a href="http://app.weibo.com/t/feed/qsbvs" rel="nofollow">手机微博触屏版</a>
    
    NSString *beigin = @"\">";
    NSString *end = @"</a>";
    
    if ([originalInfo containsString:beigin] && [originalInfo containsString:end]) {
        
        NSRange beginRange = [originalInfo rangeOfString:beigin];
        NSRange endRange = [originalInfo rangeOfString:end];
        
        // 所需要的内容Range
        NSRange sourceStringRange = NSMakeRange(beginRange.location + beginRange.length, endRange.location - (beginRange.location + beginRange.length));
        
        NSString *sourceString = [NSString stringWithFormat:@"来自 %@",[originalInfo substringWithRange:sourceStringRange]];
        // 将原本截取拼接后的字符串转换成富文本,并将全部字体颜色都设置成紫色
        NSMutableAttributedString *attributedSourceString  = [[NSMutableAttributedString alloc] initWithString:sourceString attributes:@{NSForegroundColorAttributeName: [UIColor purpleColor]}];
        
        NSString *sourceStringBegin = @"来自 ";
        NSRange sourceStringBeginRange = [sourceString rangeOfString:sourceStringBegin];
        
        NSRange neededContentStringRange = NSMakeRange(sourceStringBeginRange.location + sourceStringBeginRange.length, sourceString.length - sourceStringBeginRange.length);
        // 重新截取,将后面部分设置成橙色
        [attributedSourceString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:neededContentStringRange];
        // 字体大小
        [attributedSourceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:neededContentStringRange];
        
        return attributedSourceString;
    }
    
    return nil;
    
}


#pragma mark - 获取转发评论赞的字符串
- (NSString *)transformDisplayContentByNSNumber:(NSNumber *)aNumber withTitle:(NSString *)title {
    
    /*
     - 底部toolbar 显示的转发评论赞 格式----业务需求
     - 如果 count <= 0
     - 显示格式： 转发 评论 赞 文字
     - 如果 count > 0 && count < 10000
     - 显示格式: 是多少显示多少 例如 8888  显示 8888
     - 如果 count >= 10000
     - 显示格式: x.x 万  例如 12000  显示 1.2 万
     -  例如 10000  显示 1万  20000  显示 2万 x万
     
     */
    if (aNumber.integerValue <= 0) {
        
        return title;
    } else if (aNumber.integerValue > 0 && aNumber.integerValue < 1000) {
        
        return [NSString stringWithFormat:@"%@",aNumber];
    } else {
        
        CGFloat displayFloat = aNumber.floatValue / 10000;
        NSString *displayString = [NSString stringWithFormat:@"%.1f",displayFloat];
        
        if ([displayString containsString:@".0"]) {
            
            displayString = [displayString stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        
        return [NSString stringWithFormat:@"%@万",displayString];
    }
    
}



- (NSString *)description {
    
    NSArray *keys = [JSHomeStatusModel js_objProperties];
    
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
