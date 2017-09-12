//
//  UIImage+JKRImageAdd.m
//  BaoJiDianJing
//
//  Created by Lucky on 2017/9/12.
//  Copyright © 2017年 KaiHei. All rights reserved.
//

#import "UIImage+JKRImageAdd.h"


@implementation UIImage (JKRImageAdd)

static const char * JKR_IMAGE_CAMERA_ADD = "JKR_IMAGE_CAMERA_ADD";

- (BOOL)isFromCamera {
    return objc_getAssociatedObject(self, JKR_IMAGE_CAMERA_ADD) ? [objc_getAssociatedObject(self, JKR_IMAGE_CAMERA_ADD) boolValue] : NO;
}

- (void)setIsFromCamera:(BOOL)isFromCamera {
    objc_setAssociatedObject(self, JKR_IMAGE_CAMERA_ADD, [NSNumber numberWithInt:isFromCamera], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
