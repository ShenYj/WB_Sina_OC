//
//  JSStatusCell.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSStatusCell.h"
#import "JSStatusOriginalView.h"

static CGFloat const kStatusOriginalViewHeight = 50.f;



@interface JSStatusCell ()

@property (nonatomic) JSStatusOriginalView *originalView;

@end

@implementation JSStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

#pragma mark
#pragma mark -set up UI

- (void)prepareView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.originalView];
    
    [self.originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kStatusOriginalViewHeight);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark 
#pragma mark - lazy

- (JSStatusOriginalView *)originalView {
    
    if (_originalView == nil) {
        _originalView = [[JSStatusOriginalView alloc] init];
    }
    return _originalView;
}

@end
