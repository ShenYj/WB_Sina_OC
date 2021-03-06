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
#import "UIImageView+WebCache.h"

extern CGFloat itemSizeWH;                                 // 首页视图配图视图中每个Item的宽高

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
    //[self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:pictureModel.thumbnail_pic] placeholderImage:nil options:SDWebImageRetryFailed];
    //[self.pictureImageView yy_setImageWithURL:[NSURL URLWithString:pictureModel.thumbnail_pic] options:YYWebImageOptionShowNetworkActivity];
    
    [self.pictureImageView js_setImagewithOutCornerRadiusWithURL:pictureModel.thumbnail_pic placeholder:nil expectedSize:CGSizeMake(itemSizeWH, itemSizeWH) fillColor:self.backgroundColor];

}

#pragma mark 
#pragma mark - lazy

- (UIImageView *)pictureImageView {
    
    if (_pictureImageView == nil) {
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.backgroundColor = [UIColor whiteColor];
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImageView;
}

@end
