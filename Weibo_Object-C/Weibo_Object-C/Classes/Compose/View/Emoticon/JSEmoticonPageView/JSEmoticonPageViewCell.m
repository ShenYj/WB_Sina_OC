//
//  JSEmoticonPageViewCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonPageViewCell.h"
//#import "JSEmoticonTool.h"

extern NSInteger maxEmoticonCounts;             // 表情键盘每页展示表情最多个数
extern NSInteger const kEmoticonsColCount;      // 表情键盘中表情列数
extern CGFloat const kEmoticonToolBarHeight;    // 表情键盘底部Toolbar高度
extern CGFloat const kKeyboardViewHeigth;       // 自定义表情键盘高度


@interface JSEmoticonPageViewCell ()

@property (nonatomic) NSArray *emoticonButtons;

@end

@implementation JSEmoticonPageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    
    self.backgroundColor = [UIColor whiteColor];
    // 添加子控件
    [self.contentView addSubview:self.detail];
    // 设置约束
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth = SCREEN_WIDTH / kEmoticonsColCount;
    CGFloat buttonHeight = (kKeyboardViewHeigth - kEmoticonToolBarHeight) / 3;
    [self.emoticonButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSInteger row = idx / kEmoticonsColCount;
        NSInteger col = idx % kEmoticonsColCount;
        
        CGFloat coordinateX = col * buttonWidth;
        CGFloat coordinateY = row * buttonHeight;
        
        UIButton *button = (UIButton *)obj;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(coordinateX);
            make.top.mas_equalTo(self.contentView).mas_offset(coordinateY);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
        }];
        
    }];
    
}


#pragma mark
#pragma mark - lazy

// 创建20个表情按钮
- (NSArray *)emoticonButtons {
    
    if (_emoticonButtons == nil) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<maxEmoticonCounts; i ++) {
            UIButton *button = [[UIButton alloc] init];
            button.backgroundColor = [UIColor js_randomColor];
            [self.contentView addSubview:button];// 添加子控件
            [tempArr addObject:button];
        }
        _emoticonButtons = tempArr.copy;
    }
    return _emoticonButtons;
}

- (void)setEmoticons:(NSArray<JSEmoticonModel *> *)emoticons {
    
    _emoticons = emoticons;
    
    NSLog(@"%@",emoticons);
    
}

- (UILabel *)detail {
    
    if (_detail == nil) {
        _detail = [[UILabel alloc] init];
        _detail.font = [UIFont systemFontOfSize:50];
        _detail.textAlignment = NSTextAlignmentCenter;
        _detail.textColor = [UIColor js_randomColor];
    }
    return _detail;
}

@end
