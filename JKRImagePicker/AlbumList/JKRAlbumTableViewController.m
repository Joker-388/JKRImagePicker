//
//  JKRAlbumTableViewController.m
//  JKRImagePicker
//
//  Created by Lucky on 16/1/26.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "JKRAlbumTableViewController.h"
#import "JKRAlbum.h"
#import "JKRAlbumTableViewCell.h"
#import "JKRImageGridViewController.h"

static NSString *const JKRAlbumTableViewCellIdentifier = @"JKRAlbumTableViewCellIdentifier";

@interface JKRAlbumTableViewController ()

@end

@implementation JKRAlbumTableViewController {
    /// 相册资源集合
    NSArray<JKRAlbum *> *_assetCollection;
    /// 选中素材数组
    NSMutableArray <PHAsset *> *_selectedAssets;
}

- (instancetype)initWithSelectedAssets:(NSMutableArray<PHAsset *> *)selectedAssets {
    self = [super init];
    _selectedAssets = selectedAssets;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏
    self.title = @"照片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseButton)];
    
    // 获取相册
    [self fetchAssetCollectionWithCompletion:^(NSArray<JKRAlbum *> *assetCollection, BOOL isDenied) {
        if (isDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有权限访问相册，请先在设置程序中授权访问" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        _assetCollection = assetCollection;
        [self.tableView reloadData];
        // 默认显示第一个相册
        if (_assetCollection.count > 0) {
            JKRImageGridViewController *grid = [[JKRImageGridViewController alloc]
                                               initWithAlbum:_assetCollection[0]
                                               selectedAssets:_selectedAssets
                                               maxPickerCount:_maxPickerCount];
            [self.navigationController pushViewController:grid animated:NO];
        }
    }];
    
    // 设置表格
    [self.tableView registerClass:[JKRAlbumTableViewCell class] forCellReuseIdentifier:JKRAlbumTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
}

- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 加载相册
- (void)fetchAssetCollectionWithCompletion:(void (^)(NSArray<JKRAlbum *> *, BOOL))completion {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            [self fetchResultWithCompletion:completion];
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self fetchResultWithCompletion:completion];
            }];
        }
            break;
        default:
            NSLog(@"拒绝访问相册");
            completion(nil, YES);
            break;
    }
}

- (void)fetchResultWithCompletion:(void (^)(NSArray<JKRAlbum *> *, BOOL))completion {
    NSMutableArray *result = [NSMutableArray array];
    
    // 有所照片
    PHFetchResult *userLibrary = [PHAssetCollection
                                  fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                  subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                  options:nil];
    [userLibrary enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKRAlbum  *ablum = [JKRAlbum albumWithAssetCollection:obj];
        if (ablum) [result addObject:ablum];
    }];
    
    // 最近添加
    PHFetchResult *userLibrary1 = [PHAssetCollection
                                  fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                  subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded
                                  options:nil];
    [userLibrary1 enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKRAlbum  *ablum = [JKRAlbum albumWithAssetCollection:obj];
        if (ablum) [result addObject:ablum];
    }];
    
    // 自拍
    PHFetchResult *userLibrary2 = [PHAssetCollection
                                   fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                   subtype:PHAssetCollectionSubtypeSmartAlbumSelfPortraits
                                   options:nil];
    [userLibrary2 enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKRAlbum  *ablum = [JKRAlbum albumWithAssetCollection:obj];
        if (ablum) [result addObject:ablum];
    }];
    
    // 屏幕快照
    PHFetchResult *userLibrary3 = [PHAssetCollection
                                   fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                   subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots
                                   options:nil];
    [userLibrary3 enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKRAlbum  *ablum = [JKRAlbum albumWithAssetCollection:obj];
        if (ablum) [result addObject:ablum];
    }];
    
    // 全景
    PHFetchResult *userLibrary4 = [PHAssetCollection
                                   fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                   subtype:PHAssetCollectionSubtypeSmartAlbumPanoramas
                                   options:nil];
    [userLibrary4 enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKRAlbum  *ablum = [JKRAlbum albumWithAssetCollection:obj];
        if (ablum) [result addObject:ablum];
    }];
    
    // 连拍快照
    PHFetchResult *userLibrary6 = [PHAssetCollection
                                   fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                   subtype:PHAssetCollectionSubtypeSmartAlbumBursts
                                   options:nil];
    [userLibrary6 enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKRAlbum  *ablum = [JKRAlbum albumWithAssetCollection:obj];
        if (ablum) [result addObject:ablum];
    }];
    
    // 同步相册
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:NO]];
    
    PHFetchResult *syncedAlbum = [PHAssetCollection
                                  fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                  subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum
                                  options:options];
    
    [syncedAlbum enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKRAlbum  *ablum = [JKRAlbum albumWithAssetCollection:obj];
        if (ablum) [result addObject:ablum];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{ completion(result.copy, NO); });
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assetCollection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JKRAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JKRAlbumTableViewCellIdentifier forIndexPath:indexPath];
    cell.album = _assetCollection[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JKRAlbum *album = _assetCollection[indexPath.row];
    JKRImageGridViewController *grid = [[JKRImageGridViewController alloc]
                                       initWithAlbum:album
                                       selectedAssets:_selectedAssets
                                       maxPickerCount:_maxPickerCount];
    [self.navigationController pushViewController:grid animated:YES];
}

@end
