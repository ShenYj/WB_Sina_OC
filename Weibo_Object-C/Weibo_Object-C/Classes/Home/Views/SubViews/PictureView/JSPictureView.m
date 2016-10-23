//
//  JSPictureView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSPictureView.h"
#import "JSFlowLayout.h"
#import "JSPictureViewCell.h"
#import "JSHomeStatusModel.h"

static NSString * const pictureReusedID = @"pictureReusedID";
static CGFloat const kMargin = 10.f;
static CGFloat const kItemMargin = 5.f;

@interface JSPictureView () <UICollectionViewDataSource,UICollectionViewDelegate>

// 展示当前PictureView的配图个数
@property (nonatomic) UILabel *pictureCountsLabel;

@end

@implementation JSPictureView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:[[JSFlowLayout alloc] init]];
    if (self) {
        
        [self prepareView];
    }
    return self;
    
}


#pragma mark
#pragma mark - set up UI

- (void)prepareView {
    
    self.backgroundColor = [UIColor js_randomColor];
    
    [self registerClass:[JSPictureViewCell class] forCellWithReuseIdentifier:pictureReusedID];
    self.dataSource = self;
    self.delegate = self;
    
    [self addSubview:self.pictureCountsLabel];
    [self.pictureCountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
}

// 根据配图的个数,计算配图视图的宽度和高度 (转移至模型类<JSStatusModel>中进行计算)
- (CGSize)getPictureViewSizeWithItemCounts:(NSInteger)itemCount {
    
    // 每张配图(Cell) 的尺寸 (等高等宽)
    CGFloat itemSizeWH = ([UIScreen mainScreen].bounds.size.width - 2 * kMargin - 2 * kItemMargin) / 3;
    
    // 计算行数和列数  (itemCount == 4) ? 2 : (itemCount >= 3 ? 3 : itemCount);
    NSInteger col = (itemCount >= 3) ? (itemCount == 4 ? 2 : 3) : (itemCount == 2 ? 2 : 1);
    NSInteger row = (itemCount == 4) ? 2 : ((itemCount - 1) / 3 + 1);
    
    // 计算PictureView的宽度和高度
    CGFloat pictureViewSizeW = col * itemSizeWH + (col - 1) * kItemMargin;
    CGFloat pictureViewSizeH = row * itemSizeWH + (col - 1) * kItemMargin;
    
    return CGSizeMake(pictureViewSizeW, pictureViewSizeH);
}


#pragma mark - 
#pragma mark - set up Data & update PictureView constraint

- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    // 根据配图的个数,设置自身(PickerView)的Size  (转移至模型类<JSStatusModel>中进行计算并保存)
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(statusData.pictureItemSize);
    }];
    
    self.pictureCountsLabel.text = @(statusData.pic_urls.count).description;
}

//- (void)setPictures:(NSArray<JSHomeStatusPictureModel *> *)pictures {
//    
//    _pictures = pictures;
//    
//    // 根据配图的个数,设置自身(PickerView)的Size  (转移至模型类<JSStatusModel>中进行计算并保存)
//    // CGSize size = [self getPictureViewSizeWithItemCounts:pictures.count];
//    
//    // 设置PictureView的Size约束
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(pictures.);
//    }];
//       
//    self.pictureCountsLabel.text = @(pictures.count).description;
//    
//}

#pragma mark
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.statusData.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSHomeStatusPictureModel *pictureModel = self.statusData.pic_urls[indexPath.item];
    
    JSPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureReusedID forIndexPath:indexPath];
    
    cell.pictureModel = pictureModel;
    
    return cell;
}


#pragma mark
#pragma mark - lazy

- (UILabel *)pictureCountsLabel {
    
    if (_pictureCountsLabel == nil) {
        _pictureCountsLabel = [[UILabel alloc] init];
        _pictureCountsLabel.font = [UIFont systemFontOfSize:25];
        _pictureCountsLabel.textColor = [UIColor js_randomColor];
        _pictureCountsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pictureCountsLabel;
}

@end
