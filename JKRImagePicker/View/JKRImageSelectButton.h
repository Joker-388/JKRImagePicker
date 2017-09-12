//
//  JKRImageSelectButton.h
//  JKRImagePicker
//
//  Created by Lucky on 16/1/30.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 选择图像按钮
@interface JKRImageSelectButton : UIButton

- (instancetype)initWithImageName:(NSString *)imageName selectedName:(NSString *)selectedName;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
