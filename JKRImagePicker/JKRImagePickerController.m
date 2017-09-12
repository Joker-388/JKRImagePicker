//
//  JKRImagePickerController.m
//  JKRImagePicker
//
//  Created by Lucky on 16/1/26.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "JKRImagePickerController.h"
#import "JKRAlbumTableViewController.h"
#import "JKRImageClipViewController.h"

NSString *const JKRImagePickerDidSelectedNotification = @"JKRImagePickerDidSelectedNotification";
NSString *const JKRImagePickerDidSelectedAssetsKey = @"JKRImagePickerDidSelectedAssetsKey";
NSString *const JKRImagePickerBundleName = @"JKRImagePicker.bundle";

/// 默认选择图像大小
#define JKRImagePickerDefaultSize    CGSizeMake(600, 600)

@interface JKRImagePickerController ()<JKRImageClipViewControllerDelegate>

@end

@implementation JKRImagePickerController {
    JKRAlbumTableViewController *_rootViewController; ///< 跟控制器，相册列表
    NSMutableArray <PHAsset *> *_selectedAssets; ///< 选中素材数组
}

#pragma mark - init
- (instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)selectedAssets {
    self = [super init];
    if (selectedAssets == nil) {
        _selectedAssets = [NSMutableArray array];
    } else {
        _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
    }
    _rootViewController = [[JKRAlbumTableViewController alloc] initWithSelectedAssets:_selectedAssets];
    // 默认最大选择图像数量
    self.maxPickerCount = 9;
    [self pushViewController:_rootViewController animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedSelectAssets:) name:JKRImagePickerDidSelectedNotification object:nil];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JKRImagePickerDidSelectedNotification object:nil];
}

#pragma mark - getter & setter 方法
- (CGSize)targetSize {
    if (CGSizeEqualToSize(_targetSize, CGSizeZero)) {
        _targetSize = JKRImagePickerDefaultSize;
    }
    return _targetSize;
}

- (void)setMaxPickerCount:(NSInteger)maxPickerCount {
    _rootViewController.maxPickerCount = maxPickerCount;
}

- (NSInteger)maxPickerCount {
    return _rootViewController.maxPickerCount;
}

- (void)setAllowsEditing:(BOOL)allowsEditing {
    _rootViewController.allowsEditing = allowsEditing;
}

- (BOOL)allowsEditing {
    return _rootViewController.allowsEditing;
}

#pragma mark - 监听方法
- (void)didFinishedSelectAssets:(NSNotification *)notification {
    if (![self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishSelectedImages:selectedAssets:)] || _selectedAssets == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (self.maxPickerCount == 1 && self.allowsEditing == YES) {
        [self requestImages:_selectedAssets completed:^(NSArray<UIImage *> *images) {
            if (images.count > 0) {
                JKRImageClipViewController *controller = [[JKRImageClipViewController alloc] initWithImage:images.firstObject];
                controller.delegate = self;
                [self pushViewController:controller animated:YES];
            }
        }];
    } else {
        [self requestImages:_selectedAssets completed:^(NSArray<UIImage *> *images) {
            [self.pickerDelegate imagePickerController:self didFinishSelectedImages:images selectedAssets:_selectedAssets.copy];
        }];
    }
}

- (void)jkrImageClipViewController:(JKRImageClipViewController *)clipViewController finishClipImage:(UIImage *)image {
    [self.pickerDelegate imagePickerController:self didFinishSelectedImages:@[image] selectedAssets:_selectedAssets.copy];
}

#pragma mark - UINavigationController 父类方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.maxPickerCount > 1) {
        self.toolbarHidden = [viewController isKindOfClass:[JKRAlbumTableViewController class]];
    } else {
        self.toolbarHidden = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    if (self.maxPickerCount > 1) {
        self.toolbarHidden = (self.viewControllers.count == 1);
    } else {
        self.toolbarHidden = YES;
    }
    self.hidesBarsOnTap = NO;
    return viewController;
}

#pragma mark - 请求图像方法
/**
 根据 PHAsset 数组，统一查询用户选中图像
 @param selectedAssets 用户选中 PHAsset 数组
 @param completed 完成回调，缩放后的图像数组在回调参数中
 */
- (void)requestImages:(NSArray <PHAsset *> *)selectedAssets completed:(void (^)(NSArray <UIImage *> *images))completed {
    /// 图像请求选项
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 设置 deliveryMode 为 HighQualityFormat 可以只回调一次缩放之后的图像，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    // 设置加载图像尺寸(以像素为单位)
    CGSize targetSize = self.targetSize;
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    for (NSInteger i = 0; i < selectedAssets.count; i++) {
        [images addObject:[UIImage new]];
    }
    dispatch_group_t group = dispatch_group_create();
    NSInteger i = 0;
    for (PHAsset *asset in selectedAssets) {
        dispatch_group_enter(group);
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [images replaceObjectAtIndex:i withObject:result];
            dispatch_group_leave(group);
        }];
        i++;
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completed(images.copy);
    });
}

@end
