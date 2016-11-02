//
//  JSEmoticonPageViewCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonPageViewCell.h"

@interface JSEmoticonPageViewCell ()



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
    
    self.backgroundColor = [UIColor js_randomColor];
    
    [self.contentView addSubview:self.detail];
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark
#pragma mark - lazy

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
