//
//  JKRAlbumTableViewController.h
//  JKRImagePicker
//
//  Created by Lucky on 16/1/26.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

NS_ASSUME_NONNULL_BEGIN

/// 相册列表，图片选择器根视图
@interface JKRAlbumTableViewController : UITableViewController

- (_Nonnull instancetype)initWithSelectedAssets:(NSMutableArray <PHAsset *> * _Nullable)selectedAssets;
/// 最大选择图像数量，默认 9 张
@property (nonatomic) NSInteger maxPickerCount;
@property (nonatomic, assign) BOOL allowsEditing;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
