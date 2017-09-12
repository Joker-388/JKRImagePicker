//
//  JKRImageSelectButton.m
//  JKRImagePicker
//
//  Created by Lucky on 16/1/30.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "JKRImageSelectButton.h"
#import "JKRImagePickerGlobal.h"

@implementation JKRImageSelectButton

- (instancetype)initWithImageName:(NSString *)imageName selectedName:(NSString *)selectedName {
    self = [super initWithFrame:CGRectZero];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:JKRImagePickerBundleName withExtension:nil];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    UIImage *normalImage = [UIImage imageNamed:imageName
                                      inBundle:imageBundle
                 compatibleWithTraitCollection:nil];
    [self setImage:normalImage forState:UIControlStateNormal];
    UIImage *selectedImage = [UIImage imageNamed:selectedName
                                        inBundle:imageBundle
                   compatibleWithTraitCollection:nil];
    [self setImage:selectedImage forState:UIControlStateSelected];
    [self sizeToFit];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.selected = !self.selected;
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView
     animateWithDuration:0.25
     delay:0
     usingSpringWithDamping:0.5
     initialSpringVelocity:0
     options:UIViewAnimationOptionCurveEaseIn
     animations:^{
         self.transform = CGAffineTransformIdentity;
     } completion:^(BOOL finished) {
         id target = self.allTargets.anyObject;
         NSString *actionString = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].lastObject;
         if (actionString != nil) {
             [self sendAction:NSSelectorFromString(actionString) to:target forEvent:event];
         }
     }];
}

@end
