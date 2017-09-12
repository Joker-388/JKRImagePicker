//
//  JKRAlbumTableViewCell.m
//  JKRImagePicker
//
//  Created by Lucky on 16/1/26.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "JKRAlbumTableViewCell.h"
#import "JKRAlbum.h"

@implementation JKRAlbumTableViewCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    CGFloat iconMargin = 8.0;
    CGFloat iconWH = rect.size.height - 2 * iconMargin;
    
    self.imageView.frame = CGRectMake(iconMargin, iconMargin, iconWH, iconWH);
    
    CGFloat labelMargin = 12.0;
    CGFloat labelX = iconMargin + iconWH + labelMargin;
    CGFloat labelW = rect.size.width - labelX - labelMargin;
    self.textLabel.frame = CGRectMake(labelX, iconMargin, labelW, iconWH);
}

#pragma mark - set data
- (void)setAlbum:(JKRAlbum *)album {
    _album = album;
    self.textLabel.attributedText = album.desc;
    CGSize imageSize = CGSizeMake(80, 80);
    self.imageView.image = [album emptyImageWithSize:imageSize];
    [album requestThumbnailWithSize:imageSize completion:^(UIImage * _Nonnull thumbnail) {
        self.imageView.image = thumbnail;
    }];
}

@end
