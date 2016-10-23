//
//  JSPictureViewCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSPictureViewCell.h"
#import "JSHomeStatusModel.h"

@implementation JSPictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareView];
    }
    return self;
}

#pragma mark
#pragma mark - set up UI
- (void)prepareView {
    
    self.backgroundColor = [UIColor js_randomColor];
    
}

#pragma mark
#pragma mark - set up Data

- (void)setPictureModel:(JSHomeStatusPictureModel *)pictureModel {
    
    _pictureModel = pictureModel;
}

@end
