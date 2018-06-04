//
//  HandleImageView.m
//  10-涂鸦画板
//
//  Created by 陈弘根 on 15/8/7.
//  Copyright (c) 2015年 陈弘根. All rights reserved.
//

#import "HandleImageView.h"

@interface HandleImageView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation HandleImageView

- (UIImageView *)imageV
{
    if (_imageV == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageV = imageV;
        
        [self addSubview:imageV];
        
    }
    return _imageV;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageV.frame = self.bounds;
        // 给imageV添加手势
        [self setUpGes];
        self.imageV.userInteractionEnabled = YES;
        
        
        
        
    }
    return self;
}


// 添加UIImageView所有的手势
- (void)setUpGes
{
    // pan
    // 拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(pan:)];
    
    [self.imageV addGestureRecognizer:pan];
    
    // pinch
    [self setUpPinch];
    
    // rotation
    [self setUpRotation];
    
    // longPress
    [self setUpLongPress];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    // 获取手指平移的偏移量
    CGPoint transP = [pan translationInView:self.imageV];
    
    self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, transP.x, transP.y);
    
    // 复位
    [pan setTranslation:CGPointZero inView:self.imageV];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    // 搞个UIImageView专门展示image
    self.imageV.image = image;
    
}

#pragma mark - 添加捏合手势
- (void)setUpPinch
{
    // 捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    pinch.delegate = self;
    
    [self.imageV addGestureRecognizer:pinch];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    
    self.imageV.transform = CGAffineTransformScale(self.imageV.transform, pinch.scale, pinch.scale);
    
    // 复位
    pinch.scale = 1;
}

#pragma mark - 
// Simultaneously:同时
// 是否同时支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - 添加旋转手势
- (void)setUpRotation
{
    // 旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    
    rotation.delegate = self;
    
    [self.imageV addGestureRecognizer:rotation];
}
- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    

    
    // 旋转图片
    self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, rotation.rotation);
    
    // 复位,只要想相对于上一次旋转就复位
    rotation.rotation = 0;
    
}

#pragma mark - 添加长按手势
- (void)setUpLongPress
{
    // 长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self.imageV addGestureRecognizer:longPress];
    
}

// 什么时候调用:长按的时候调用,而且只要手指不离开,拖动的时候会一直调用,手指抬起的时候也会调用
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    // 注意：在以后开发中,长按手势一般需要做判断
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        // 一闪的动画
        [UIView animateWithDuration:0.25 animations:^{
            self.imageV.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.imageV.alpha = 1;
            } completion:^(BOOL finished) {
                
                
                // 把处理图片的View截屏.生成一张新的图片,展示到画板上
                
                // 开启位图上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                
                // 渲染图层
                [self.layer renderInContext:UIGraphicsGetCurrentContext()];
                
                // 从上下文中取出图片
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                
                // 关闭上下文
                UIGraphicsEndImageContext();
                
                // 数据传值的步骤
                // 1.接收方要有属性接收 接收方:drawView
                // 2.拿到drawView,
//                _drawView.image = image;
                
                // 处理图片完成的时候通知代理做事情,只要让代理是drawView
                if ([_delegate respondsToSelector:@selector(handleImageView:didHandleImage:)]) {
                    [_delegate handleImageView:self didHandleImage:image];
                }
                
                // 把处理图片的view移除父控件
                [self removeFromSuperview];
                
            }];
            
        }];
    }
}



@end
