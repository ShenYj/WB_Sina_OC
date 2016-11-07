//
//  JSEmoticonPageViewCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonPageViewCell.h"
#import "JSEmoticonButton.h"
#import "JSEmoticonModel.h"
#import "JSEmoticonTool.h"

extern NSInteger maxEmoticonCounts;                       // 表情键盘每页展示表情最多个数
extern NSInteger const kEmoticonsColCount;                // 表情键盘中表情列数
extern CGFloat const kEmoticonToolBarHeight;              // 表情键盘底部Toolbar高度
extern CGFloat const kKeyboardViewHeigth;                 // 自定义表情键盘高度
extern CGFloat const kEmoticonPageViewHorizontalMargin;   // 表情键盘左右两侧间距
extern CGFloat const kEmoticonPageViewBottomMargin;       // 表情键盘表情区域底部间距


@interface JSEmoticonPageViewCell ()

// 表情按钮数组
@property (nonatomic) NSArray <JSEmoticonButton *>*emoticonButtons;
// 删除按钮
@property (nonatomic) UIButton *deleteButton;

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
    
    
    
}

// 设置表情按钮和删除按钮约束
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth = (SCREEN_WIDTH - 2*kEmoticonPageViewHorizontalMargin) / kEmoticonsColCount;
    CGFloat buttonHeight = (kKeyboardViewHeigth - kEmoticonToolBarHeight - kEmoticonPageViewBottomMargin) / 3;
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
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-kEmoticonPageViewHorizontalMargin);
        make.bottom.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
    }];
    
}

#pragma mark
#pragma mark - 设置表情按钮
- (void)setEmoticons:(NSArray<JSEmoticonModel *> *)emoticons {
    
    _emoticons = emoticons;
    
    // 解决Cell重用显示表情问题,默认全部隐藏
    for (JSEmoticonButton *emoticonButton in self.emoticonButtons) {
        emoticonButton.hidden = YES;
    }
    
    // 遍历表情数组容器,给Button赋值 (遍历Button会出现数组越界问题)
    [emoticons enumerateObjectsUsingBlock:^(JSEmoticonModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        JSEmoticonModel *emoticonModel = (JSEmoticonModel *)obj;
        JSEmoticonButton *emoticonButton = self.emoticonButtons[idx];
        // 给表情按钮设置属性
        emoticonButton.emoticonModel = emoticonModel;
        // 显示按钮
        emoticonButton.hidden = NO;
        
        if (emoticonModel.isEmoji) {
            // emoji表情
            NSString *emojiEmoticon = [emoticonModel.code emoji];
            [emoticonButton setTitle:emojiEmoticon forState:UIControlStateNormal];
            [emoticonButton setImage:nil forState:UIControlStateNormal];
            
        } else {
            
            // 拼接Bundle下的完整路径
            NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@",emoticonModel.path,emoticonModel.png];
            // 从Emoticons.bundle中加载图片
            UIImage *image = [UIImage imageNamed:fileFullPath inBundle:[JSEmoticonTool shared].emoticonsBundle compatibleWithTraitCollection:nil];
            // 图片表情
            [emoticonButton setTitle:nil forState:UIControlStateNormal];
            [emoticonButton setImage:image forState:UIControlStateNormal];
            
        }
        
    }];
    
}

#pragma mark - 表情按钮&删除按钮点击事件

// 点击删除表情按钮
- (void)clickDeleteEmoticonButton:(UIButton *)sender {
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteEmoticonButtonNotification" object:nil userInfo:nil];
}

// 点击表情按钮事件
- (void)clickEmoticonButton:(JSEmoticonButton *)button {
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickEmoticonButtonNotification" object:button.emoticonModel userInfo:nil];
}

#pragma mark
#pragma mark - lazy

// 创建20个表情按钮
- (NSArray <JSEmoticonButton *>*)emoticonButtons {
    
    if (_emoticonButtons == nil) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<maxEmoticonCounts; i ++) {
            JSEmoticonButton *button = [[JSEmoticonButton alloc] init];
            [button addTarget:self action:@selector(clickEmoticonButton:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = self.backgroundColor;
            [self.contentView addSubview:button];// 添加子控件
            [tempArr addObject:button];
        }
        _emoticonButtons = tempArr.copy;
    }
    return _emoticonButtons;
}

- (UIButton *)deleteButton {
    
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [_deleteButton addTarget:self action:@selector(clickDeleteEmoticonButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];// 添加子控件
    }
    return _deleteButton;
}

@end
