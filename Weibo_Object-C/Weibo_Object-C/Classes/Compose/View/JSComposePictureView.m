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


static NSString * const reusedId = @"pictureViewCell";

@interface JSComposePictureView () <UICollectionViewDataSource>

@property (nonatomic) NSArray <UIImage *> *images;

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
    
    [self registerClass:[JSComposePictureViewCell class] forCellWithReuseIdentifier:reusedId];
    self.dataSource = self;
    self.backgroundColor = [UIColor js_randomColor];
}

// 添加图片
- (void)insertImage:(UIImage *)image {
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.images];
    
    [tempArr addObject:image];
    
    self.images = tempArr.copy;
    
}


#pragma mark
#pragma mark - DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSComposePictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedId forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor js_randomColor];
    
    return cell;
}


#pragma mark
#pragma mark - lazy

- (NSArray<UIImage *> *)images {
    
    if (_images == nil) {
        _images = [NSArray array];
    }
    return _images;
}

@end
