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
#import "JSHomeStatusLayout.h"
#import "SDPhotoBrowser.h"
#import "JSHomeStatusPictureModel.h"

static NSString * const pictureReusedID = @"pictureReusedID";
// 引用JSHomeStatusModel中的 kItemMargin全局变量(这里并未使用,仅仅是为了避免最后不再使用也没有注释的方法中报错)
extern CGFloat kMargin;
extern CGFloat kItemMargin;
//extern CGSize pictureViewMaxSize;


@interface JSPictureView () <UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate>

@end

@implementation JSPictureView


- (instancetype)init {
    
    self = [super initWithFrame:CGRectZero collectionViewLayout:[[JSFlowLayout alloc] init]];
    if (self) {
        
        [self prepareCollectionView];
    }
    return self;
    
}

#pragma mark
#pragma mark - set up UI

- (void)prepareCollectionView {
    
    // 设置背景色
    self.backgroundColor = [UIColor js_colorWithHex:0xE8E8E8];
    // 注册Cell
    [self registerClass:[JSPictureViewCell class] forCellWithReuseIdentifier:pictureReusedID];
    // 设置代理
    self.dataSource = self;
    self.delegate = self;
    
}

#pragma mark - 
#pragma mark - set up Data & update PictureView constraint

- (void)setStatusData:(JSHomeStatusModel *)statusData {
    
    _statusData = statusData;
    // 根据配图的个数,设置自身(PickerView)的Size  (转移至模型类<JSStatusModel>中进行计算并保存)
    CGSize pictureViewSize = statusData.pictureViewSize;
    
    // 如果没有配图,就给配图视图设置一个最大值(9张配图尺寸)
    if (!statusData.pic_urls) {
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(statusData.homeStatusLayout.HomeStatusLayoutPictureViewMaxSize);
        }];
    } else {
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(pictureViewSize);
        }];
        
    }
    
    // 获取到数据后,刷新CollectionView
    [self reloadData];
    
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
#pragma mark - SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    JSPictureViewCell *cell = (JSPictureViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.pictureImageView.image;
    
//    JSHomeStatusPictureModel *pictureModel = self.statusData.pic_urls[index];
//    UIImage *image = [UIImage imageNamed:pictureModel.thumbnail_pic];
//    return image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    JSHomeStatusPictureModel *pictureModel = self.statusData.pic_urls[index];
    NSString *imageUrlString = pictureModel.thumbnail_pic;
    return [NSURL URLWithString:[imageUrlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
}


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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.sourceImagesContainerView = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = self.statusData.pic_urls.count;
    [photoBrowser show];
}


// 根据配图的个数,计算配图视图的宽度和高度 (转移至模型类<JSStatusModel>中进行计算)
- (CGSize)getPictureViewSizeWithItemCounts:(NSInteger)itemCount {
    
    // 每张配图(Cell) 的尺寸 (等高等宽)
    CGFloat itemSizeWH = ([UIScreen mainScreen].bounds.size.width - 2 * kMargin - 2 * kItemMargin) / 3;
    
    // 计算行数和列数  (itemCount == 4) ? 2 : (itemCount >= 3 ? 3 : itemCount);
    NSInteger col = (itemCount >= 3) ? (itemCount == 4 ? 2 : 3) : (itemCount == 2 ? 2 : 1);
    //NSInteger row = (itemCount == 4) ? 2 : ((itemCount - 1) / 3 + 1);
     NSInteger row = ((itemCount - 1) / 3 + 1);
    // 计算PictureView的宽度和高度
    CGFloat pictureViewSizeW = col * itemSizeWH + (col - 1) * kItemMargin;
    CGFloat pictureViewSizeH = row * itemSizeWH + (col - 1) * kItemMargin;
    
    return CGSizeMake(pictureViewSizeW, pictureViewSizeH);
}



@end
