//
//  JSComposePictureView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/29.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSComposePictureView.h"
#import "JSPictureViewFlowLayout.h"
#import "JSComposePictureViewCell.h"

// 重用标识
static NSString * const reusedId = @"pictureViewCell";

@interface JSComposePictureView () <UICollectionViewDataSource,UICollectionViewDelegate>


@end

@implementation JSComposePictureView

// 构造函数
- (instancetype)init {
    
    self = [super initWithFrame:CGRectZero collectionViewLayout:[[JSPictureViewFlowLayout alloc] init]];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

// 设置视图
- (void)prepareView {
    
    // 默认隐藏
    self.hidden = YES;
    [self registerClass:[JSComposePictureViewCell class] forCellWithReuseIdentifier:reusedId];
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
}

// 添加图片
- (void)insertImage:(UIImage *)image {
    
    //[self.images addObject:image];
    [self.images insertObject:image atIndex:0];
    
    // 如果图片数量大于9,移除最后一个元素
    if (self.images.count > 9) {
        [self.images removeLastObject];
    }
    // 添加图片后显示视图
    self.hidden = NO;
    
    [self reloadData];
    
}


#pragma mark
#pragma mark - DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.images.count == 0 || self.images.count == 9) {
        
        return self.images.count;
    } else {
        
        return self.images.count + 1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSComposePictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedId forIndexPath:indexPath];
    
    if (indexPath.item == self.images.count) {
        
        cell.pictureImage = nil;
    } else {
        
        cell.pictureImage = self.images[indexPath.item];
    }
    
    // 删除按钮Block实现
    __weak typeof(self) weakSelf = self;
    [cell setDeleteImageHandler:^{
        
        [weakSelf.images removeObjectAtIndex:indexPath.item];
        // 如果配图为0,隐藏视图
        if (weakSelf.images.count == 0) {
            weakSelf.hidden = YES;
        }
        [weakSelf reloadData];
    }];
    
    return cell;
}

#pragma mark
#pragma mark - Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.images.count) {
        
        // 添加图片
        if (self.inserImageHandler) {
            self.inserImageHandler();
        }
    }
    
}


#pragma mark
#pragma mark - lazy

- (NSMutableArray<UIImage *> *)images {
    
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end
