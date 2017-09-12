//
//  JKRViewerViewController.h
//  JKRImagePicker
//
//  Created by Lucky on 16/1/29.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface JKRViewerViewController : UIViewController
/// 图像索引
@property (nonatomic) NSUInteger index;
/// 图像资源
@property (nonatomic) PHAsset *asset;
@end
