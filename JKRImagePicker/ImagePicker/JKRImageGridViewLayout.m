//
//  JKRImageGridViewLayout.m
//  JKRImagePicker
//
//  Created by Lucky on 16/1/29.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "JKRImageGridViewLayout.h"

/// 最小 Cell 宽高
#define JKRGridCellMinWH 104

@implementation JKRImageGridViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat margin = 2;
    CGFloat itemWH = [self itemWHWithCount:3 margin:margin];
    
    self.itemSize = CGSizeMake(itemWH, itemWH);
    self.minimumInteritemSpacing = margin;
    self.minimumLineSpacing = margin;
    self.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (CGFloat)itemWHWithCount:(NSInteger)count margin:(CGFloat)margin {
    
    CGFloat itemWH = 0;
    CGSize size = self.collectionView.bounds.size;
    
    do {
        itemWH = floor((size.width - (count + 1) * margin) / count);
        count++;
    } while (itemWH > JKRGridCellMinWH);
    
    
    return itemWH;
}

@end
