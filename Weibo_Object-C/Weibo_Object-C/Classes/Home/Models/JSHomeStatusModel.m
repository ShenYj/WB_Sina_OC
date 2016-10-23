
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
