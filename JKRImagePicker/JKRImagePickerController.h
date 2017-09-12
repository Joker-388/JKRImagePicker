//
//  JKRImagePickerController.h
//  JKRImagePicker
//
//  Created by Lucky on 16/1/26.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+JKRImageAdd.h"
@import Photos;
@class JKRImagePickerController;

NS_ASSUME_NONNULL_BEGIN

/// 图像选择控制器协议
@protocol JKRImagePickerControllerDelegate <NSObject>

@optional
/**
 图像选择完成代理方法
 @param picker 图像选择控制器
 @param images 用户选中图像数组
 @param selectedAssets 选中素材数组，方便重新定位图像
 */
- (void)imagePickerController:(JKRImagePickerController * _Nonnull)picker
      didFinishSelectedImages:(NSArray <UIImage *> * _Nonnull)images
               selectedAssets:(NSArray <PHAsset *> * _Nullable)selectedAssets;
@end

/// 图像选择控制器
@interface JKRImagePickerController : UINavigationController

/**
 构造函数
 @param selectedAssets 已选择的图片
 */
- (_Nonnull instancetype)initWithSelectedAssets:(NSArray <PHAsset *> * _Nullable)selectedAssets;
/// 图像选择代理
@property (nonatomic, weak, nullable) id<JKRImagePickerControllerDelegate> pickerDelegate;
/// 加载图像尺寸(以像素为单位，默认大小 600 * 600)
@property (nonatomic) CGSize targetSize;
/// 最大选择图像数量，默认 9 张
@property (nonatomic) NSInteger maxPickerCount;

@property (nonatomic, assign) BOOL allowsEditing;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
