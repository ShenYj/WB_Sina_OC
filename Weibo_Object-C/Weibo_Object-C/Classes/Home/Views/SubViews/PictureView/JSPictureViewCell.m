//
//  JSPictureViewCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSPictureViewCell.h"
#import "JSHomeStatusModel.h"
#import "JSHomeStatusPictureModel.h"
#import "YYAnimatedImageView.h"



@implementation JSPictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareView];
        
        // 栅格化
        self.layer.shouldRasterize = YES;
        // 设置缩放比
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        // 开启异步绘制
        [self.layer drawsAsynchronously];
    }
    return self;
}

#pragma mark
#pragma mark - set up UI
- (void)prepareView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.pictureImageView];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsZero);
    }];
    
}

#pragma mark
#pragma mark - set up Data

- (void)setPictureModel:(JSHomeStatusPictureModel *)pictureModel {
    
    _pictureModel = pictureModel;
    
    // 设置配图
    [self.pictureImageView yy_setImageWithURL:[NSURL URLWithString:pictureModel.thumbnail_pic] options:YYWebImageOptionShowNetworkActivity];
}

#pragma mark 
#pragma mark - lazy

- (YYAnimatedImageView *)pictureImageView {
    
    if (_pictureImageView == nil) {
        _pictureImageView = [[YYAnimatedImageView alloc] init];
        _pictureImageView.backgroundColor = [UIColor whiteColor];
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImageView;
}

@end
