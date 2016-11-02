//
//  JSEmoticonPageView.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/1.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonPageView.h"
#import "JSEmoticonPageViewFlowLayout.h"
#import "JSEmoticonPageViewCell.h"
#import "JSEmoticonTool.h"


static NSString * const reusedId = @"恶魔体从PageViewCell";

@implementation JSEmoticonPageView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame collectionViewLayout:[[JSEmoticonPageViewFlowLayout alloc] init]];
    if (self) {
        
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    
    self.backgroundColor = [UIColor js_randomColor];
    [self registerClass:[JSEmoticonPageViewCell class] forCellWithReuseIdentifier:reusedId];
    self.dataSource = self;
}


#pragma mark 
#pragma mark - DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [JSEmoticonTool shared].allEmoticons.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *emoticons = [JSEmoticonTool shared].allEmoticons[section];
    return emoticons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSEmoticonPageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedId forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor js_randomColor];
    
    cell.detail.text = [NSString stringWithFormat:@"%@组--%@页",@(indexPath.section),@(indexPath.item)];
    
    return cell;
}

@end
