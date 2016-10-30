//
//  JSComposePictureViewCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/29.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposePictureViewCell.h"

@interface JSComposePictureViewCell ()

@property (nonatomic) UIImageView *pictureImageView;

@end

@implementation JSComposePictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.pictureImageView];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsZero);
    }];
    
}

- (void)setPictureImage:(UIImage *)pictureImage {
    
    _pictureImage = pictureImage;
    
    self.pictureImageView.image = pictureImage;
}

#pragma mark
#pragma mark - lazy

- (UIImageView *)pictureImageView {
    
    if (_pictureImageView == nil) {
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.backgroundColor = [UIColor js_randomColor];
        //_pictureImageView.clipsToBounds = YES;
        //_pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImageView;
}

@end
