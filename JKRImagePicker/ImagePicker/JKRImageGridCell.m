//
//  JKRImageGridCell.m
//  JKRImagePicker
//
//  Created by Lucky on 16/1/29.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "JKRImageGridCell.h"

@implementation JKRImageGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.selectedButton];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    
    CGFloat offsetX = self.bounds.size.width - _selectedButton.bounds.size.width;
    _selectedButton.frame = CGRectOffset(_selectedButton.bounds, offsetX, 0);
    _selectedButton.hidden = _singlePhoto;
}

#pragma mark - 点击选择按钮
- (void)clickSelectedButton {
    [self.delegate imageGridCell:self didSelected:_selectedButton.selected];
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (JKRImageSelectButton *)selectedButton {
    if (_selectedButton == nil) {
        _selectedButton = [[JKRImageSelectButton alloc]
                           initWithImageName:@"check_box_default"
                           selectedName:@"check_box_right"];
        [_selectedButton addTarget:self action:@selector(clickSelectedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

@end
