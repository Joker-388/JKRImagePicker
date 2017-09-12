//
//  JKRImageClipViewController.m
//  JKRImagePicker
//
//  Created by Lucky on 2017/9/11.
//  Copyright © 2017年 KaiHei. All rights reserved.
//

#import "JKRImageClipViewController.h"

@interface JKRImageClipViewController ()

@property (nonatomic, assign) CGFloat scaleRation;//图片缩放的最大倍数
@property (nonatomic, assign) CGFloat radius; //圆形裁剪框的半径
@property (nonatomic, assign) CGRect circularFrame;//裁剪框的frame
@property (nonatomic, assign) CGRect OriginalFrame;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *overView;
@property (nonatomic, strong) UIView *imageViewScale;

@end

@implementation JKRImageClipViewController {
    CGFloat lastScale;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    _image = [self fixOrientation:image];
    self.radius = [UIScreen mainScreen].bounds.size.width * 0.5;
    self.scaleRation =  6;
    lastScale = 1.0;
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self addAllGesture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)creatUI {
    //验证 裁剪半径是否有效
    self.radius= self.radius > self.view.frame.size.width/2?self.view.frame.size.width/2:self.radius;
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = (_image.size.height / _image.size.width) * self.view.frame.size.width;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _imageView = [[UIImageView alloc]init];
    [_imageView setImage:_image];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView setFrame:CGRectMake(0, 0, width, height)];
    [_imageView setCenter:self.view.center];
    self.OriginalFrame = _imageView.frame;
    [self.view addSubview:_imageView];
    
    _imageViewScale = _imageView;
    
    //覆盖层
    _overView = [[UIView alloc]init];
    [_overView setBackgroundColor:[UIColor clearColor]];
    _overView.opaque = NO;
    [_overView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:_overView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clipBtnSelected:)];
    
    [self drawClipPath];
    [self makeImageViewFrameAdaptClipFrame];
}

//绘制裁剪框
- (void)drawClipPath {
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = self.view.center;
    
    self.circularFrame = CGRectMake(center.x - self.radius, center.y - self.radius, self.radius * 2, self.radius * 2);
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(center.x - self.radius, center.y - self.radius, self.radius * 2, self.radius * 2)]];
    [path setUsesEvenOddFillRule:YES];
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor blackColor] CGColor];
    layer.opacity = 0.5;
    [_overView.layer addSublayer:layer];
}

//让图片自己适应裁剪框的大小
- (void)makeImageViewFrameAdaptClipFrame {
    CGFloat width = _imageView.frame.size.width ;
    CGFloat height = _imageView.frame.size.height;
    if(height < self.circularFrame.size.height) {
        width = (width / height) * self.circularFrame.size.height;
        height = self.circularFrame.size.height;
        CGRect frame = CGRectMake(0, 0, width, height);
        [_imageView setFrame:frame];
        [_imageView setCenter:self.view.center];
    }
}
- (void)addAllGesture {
    //捏合手势
    UIPinchGestureRecognizer * pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGesture:)];
    [self.view addGestureRecognizer:pinGesture];
    //拖动手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)handlePinGesture:(UIPinchGestureRecognizer *)pinGesture {
    UIView * view = _imageView;
    if (pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(_imageViewScale.transform, pinGesture.scale,pinGesture.scale);
        pinGesture.scale = 1.0;
    } else if (pinGesture.state == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        CGFloat ration =  view.frame.size.width /self.OriginalFrame.size.width;
        if(ration>_scaleRation) { // 缩放倍数 > 自定义的最大倍数
            CGRect newFrame =CGRectMake(0, 0, self.OriginalFrame.size.width * _scaleRation, self.OriginalFrame.size.height * _scaleRation);
            view.frame = newFrame;
        } else if (view.frame.size.width < self.circularFrame.size.width && self.OriginalFrame.size.width <= self.OriginalFrame.size.height) {
            view.frame = [self handelWidthLessHeight:view];
            view.frame = [self handleScale:view];
        } else if (view.frame.size.height< self.circularFrame.size.height && self.OriginalFrame.size.height <= self.OriginalFrame.size.width) {
            view.frame =[self handleHeightLessWidth:view];
            view.frame = [self handleScale:view];
        } else {
            view.frame = [self handleScale:view];
        }
        self.currentFrame = view.frame;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    UIView * view = _imageView;
    
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        
        [panGesture setTranslation:CGPointZero inView:view.superview];
    } else if ( panGesture.state == UIGestureRecognizerStateEnded) {
        CGRect currentFrame = view.frame;
        //向右滑动 并且超出裁剪范围后
        if(currentFrame.origin.x >= self.circularFrame.origin.x) {
            currentFrame.origin.x =self.circularFrame.origin.x;
        }
        //向下滑动 并且超出裁剪范围后
        if(currentFrame.origin.y >= self.circularFrame.origin.y) {
            currentFrame.origin.y = self.circularFrame.origin.y;
        }
        //向左滑动 并且超出裁剪范围后
        if(currentFrame.size.width + currentFrame.origin.x < self.circularFrame.origin.x + self.circularFrame.size.width) {
            CGFloat movedLeftX =fabs(currentFrame.size.width + currentFrame.origin.x -(self.circularFrame.origin.x + self.circularFrame.size.width));
            currentFrame.origin.x += movedLeftX;
        }
        //向上滑动 并且超出裁剪范围后
        if(currentFrame.size.height+currentFrame.origin.y < self.circularFrame.origin.y + self.circularFrame.size.height) {
            CGFloat moveUpY =fabs(currentFrame.size.height + currentFrame.origin.y -(self.circularFrame.origin.y + self.circularFrame.size.height));
            currentFrame.origin.y += moveUpY;
        }
        [UIView animateWithDuration:0.05 animations:^{
            [view setFrame:currentFrame];
        }];
    }
}

//缩放结束后 确保图片在裁剪框内
- (CGRect)handleScale:(UIView *)view {
    // 图片.right < 裁剪框.right
    if (view.frame.origin.x + view.frame.size.width < self.circularFrame.origin.x+self.circularFrame.size.width) {
        CGFloat right =view.frame.origin.x + view.frame.size.width;
        CGRect viewFrame = view.frame;
        CGFloat space = self.circularFrame.origin.x+self.circularFrame.size.width - right;
        viewFrame.origin.x+=space;
        view.frame = viewFrame;
    }
    // 图片.top < 裁剪框.top
    if (view.frame.origin.y > self.circularFrame.origin.y) {
        CGRect viewFrame = view.frame;
        viewFrame.origin.y=self.circularFrame.origin.y;
        view.frame = viewFrame;
    }
    // 图片.left < 裁剪框.left
    if (view.frame.origin.x > self.circularFrame.origin.x) {
        CGRect viewFrame = view.frame;
        viewFrame.origin.x=self.circularFrame.origin.x;
        view.frame = viewFrame;
    }
    // 图片.bottom < 裁剪框.bottom
    if((view.frame.size.height +view.frame.origin.y) < (self.circularFrame.origin.y + self.circularFrame.size.height)) {
        CGRect viewFrame = view.frame;
        CGFloat space = self.circularFrame.origin.y + self.circularFrame.size.height - (view.frame.size.height +view.frame.origin.y);
        viewFrame.origin.y +=space;
        view.frame = viewFrame;
    }
    
    return view.frame;
}

// 图片的高<宽 并且缩放后的图片高小于裁剪框的高
- (CGRect )handleHeightLessWidth:(UIView *)view {
    CGRect tempFrame = view.frame;
    CGFloat rat = self.OriginalFrame.size.width / self.OriginalFrame.size.height;
    CGFloat width = self.circularFrame.size.width * rat;
    CGFloat height = self.circularFrame.size.height ;
    CGFloat  x  = view.frame.origin.x ;
    CGFloat y = self.circularFrame.origin.y;
    
    if(view.frame.origin.x > self.circularFrame.origin.x) {
        x = self.circularFrame.origin.x;
    } else if ((view.frame.origin.x+view.frame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width) {
        x = self.circularFrame.origin.x + self.circularFrame.size.width - width ;
    }
    
    CGRect newFrame =CGRectMake(x, y, width,height);
    view.frame = newFrame;
    
    if ((tempFrame.origin.x > self.circularFrame.origin.x && (tempFrame.origin.x+tempFrame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width)) {
        [view setCenter:self.view.center];
    }
    
    if ((tempFrame.origin.y > self.circularFrame.origin.y &&(tempFrame.origin.y+tempFrame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height)) {
        [view setCenter:CGPointMake(tempFrame.size.width/2 + tempFrame.origin.x, view.frame.size.height/2)];
    }
    return  view.frame;
}

//图片的宽<高 并且缩放后的图片宽小于裁剪框的宽
- (CGRect)handelWidthLessHeight:(UIView *)view {
    CGFloat rat = self.OriginalFrame.size.height / self.OriginalFrame.size.width;
    CGRect tempFrame = view.frame;
    
    CGFloat width = self.circularFrame.size.width;
    CGFloat height = self.circularFrame.size.height * rat ;
    
    CGFloat  x  = self.circularFrame.origin.x ;
    CGFloat y = view.frame.origin.y;
    
    if(view.frame.origin.y > self.circularFrame.origin.y) {
        y = self.circularFrame.origin.y;
    } else if ((view.frame.origin.y+view.frame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height) {
        y = self.circularFrame.origin.y + self.circularFrame.size.height - height ;
    }
    CGRect newFrame =CGRectMake(x, y, width,height);
    view.frame = newFrame;
    
    if ((tempFrame.origin.y > self.circularFrame.origin.y &&(tempFrame.origin.y+tempFrame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height)) {
        [view setCenter:self.view.center];
    }
    if ((tempFrame.origin.x > self.circularFrame.origin.x &&(tempFrame.origin.x+tempFrame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width)) {
        [view setCenter:CGPointMake(view.frame.size.width/2, tempFrame.size.height /2 + tempFrame.origin.y)];
    }
    return  view.frame;
}

- (void)clipBtnSelected:(UIButton *)btn {
    [self.delegate jkrImageClipViewController:self finishClipImage:[self getSmallImage]];
}

//修复图片显示方向问题
- (UIImage *)fixOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//方形裁剪
- (UIImage *)getSmallImage {
    CGFloat width= _imageView.frame.size.width;
    CGFloat rationScale = (width /_image.size.width);
    
    CGFloat origX = (self.circularFrame.origin.x - _imageView.frame.origin.x) / rationScale;
    CGFloat origY = (self.circularFrame.origin.y - _imageView.frame.origin.y) / rationScale;
    CGFloat oriWidth = self.circularFrame.size.width / rationScale;
    CGFloat oriHeight = self.circularFrame.size.height / rationScale;
    
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
    CGImageRef  imageRef = CGImageCreateWithImageInRect(_image.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    
    return clipImage;
}

@end
