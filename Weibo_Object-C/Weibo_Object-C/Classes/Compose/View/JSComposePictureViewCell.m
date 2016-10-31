//
//  JSComposePictureViewCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/29.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposePictureViewCell.h"

@interface JSComposePictureViewCell ()

// 图片框
@property (nonatomic) UIImageView *pictureImageView;
// 删除图片按钮
@property (nonatomic) UIButton *deleteButton;

@end

@implementation JSComposePictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareView];
    }
    return self;
}

// 设置视图
- (void)prepareView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.pictureImageView];
    [self.contentView addSubview:self.deleteButton];
    
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsZero);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.contentView);
    }];
}

// 设置图片
- (void)setPictureImage:(UIImage *)pictureImage {
    
    _pictureImage = pictureImage;
    
    if (pictureImage) {
        // 配图
        self.deleteButton.hidden = NO;
        self.pictureImageView.image = pictureImage;
        self.pictureImageView.highlightedImage = nil;
    } else {
        // 添加配图Button
        self.deleteButton.hidden = YES;
        self.pictureImageView.image = [UIImage imageNamed:@"compose_pic_add"];
        self.pictureImageView.highlightedImage = [UIImage imageNamed:@"compose_pic_add_highlighted"];
    }
    
}

// 删除按钮点击事件
- (void)clickDeleteButton:(UIButton *)sender {
    
    if (self.deleteImageHandler) {
        self.deleteImageHandler();
    }
}

#pragma mark
#pragma mark - lazy

- (UIImageView *)pictureImageView {
    
    if (_pictureImageView == nil) {
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImageView;
}

- (UIButton *)deleteButton {
    
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
