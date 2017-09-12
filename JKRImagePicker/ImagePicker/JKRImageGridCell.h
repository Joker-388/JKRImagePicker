//
//  JKRImageGridCell.h
//  JKRImagePicker
//
//  Created by Lucky on 16/1/29.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKRImageSelectButton.h"
@class JKRImageGridCell;

@protocol JKRImageGridCellDelegate <NSObject>

- (void)imageGridCell:(JKRImageGridCell *)cell didSelected:(BOOL)selected;

@end

/// 多图选择视图 Cell
@interface JKRImageGridCell : UICollectionViewCell

@property (nonatomic, weak) id<JKRImageGridCellDelegate> delegate;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) JKRImageSelectButton *selectedButton;
@property (nonatomic, assign) BOOL singlePhoto;

@end

