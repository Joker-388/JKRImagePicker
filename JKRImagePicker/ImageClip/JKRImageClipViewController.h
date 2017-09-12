//
//  JKRImageClipViewController.h
//  JKRImagePicker
//
//  Created by Lucky on 2017/9/11.
//  Copyright © 2017年 KaiHei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRImageClipViewController;

@protocol JKRImageClipViewControllerDelegate <NSObject>

-(void)jkrImageClipViewController:(JKRImageClipViewController *)clipViewController finishClipImage:(UIImage *)image;

@end

@interface JKRImageClipViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<JKRImageClipViewControllerDelegate> delegate;
-(instancetype)initWithImage:(UIImage *)image;

@end
