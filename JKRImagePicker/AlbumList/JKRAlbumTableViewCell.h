//
//  JKRAlbumTableViewCell.h
//  JKRImagePicker
//
//  Created by Lucky on 16/1/26.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRAlbum;

/// 相册列表单元格
@interface JKRAlbumTableViewCell : UITableViewCell
/// 相册模型
@property (nonatomic) JKRAlbum *album;
@end
