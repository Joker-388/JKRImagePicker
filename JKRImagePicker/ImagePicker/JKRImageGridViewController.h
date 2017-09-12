//
//  JKRImageGridViewController.h
//  JKRImagePicker
//
//  Created by Lucky on 16/1/26.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKRAlbum.h"

/// 图片选择控制器
@interface JKRImageGridViewController : UICollectionViewController

/**
 图片选择控制器

 @param album 相册模型
 @param selectedAssets 选中资源数组
 @param maxPickerCount 最大选择数量
 @return 多图选择控制器
 */
- (instancetype)initWithAlbum:(JKRAlbum *)album
               selectedAssets:(NSMutableArray <PHAsset *> *)selectedAssets
               maxPickerCount:(NSInteger)maxPickerCount;

@end
