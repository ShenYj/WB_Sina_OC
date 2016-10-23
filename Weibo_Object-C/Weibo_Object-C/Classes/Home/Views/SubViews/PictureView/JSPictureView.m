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

@interface JSPictureView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) NSArray <JSHomeStatusPictureModel *>*pictures;

@end

@implementation JSPictureView

- (instancetype)initWithFrame:(CGRect)frame withPictures:(NSArray <JSHomeStatusPictureModel *>*)pictures {
    self = [super initWithFrame:frame collectionViewLayout:[[JSFlowLayout alloc] init]];
    if (self) {
        
        // 赋值
        self.pictures = pictures;
        
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
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
}

#pragma mark
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureReusedID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor js_randomColor];
    
    return cell;
}

@end
