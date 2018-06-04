//
//  DrawView.m
//  10-涂鸦画板
//
//  Created by 陈弘根 on 15/8/4.
//  Copyright (c) 2015年 陈弘根. All rights reserved.
//

#import "DrawView.h"

#import "DrawPath.h"

@interface DrawView ()

@property (nonatomic, strong) NSMutableArray *paths;


@property (nonatomic, strong) UIBezierPath *path;


@end


@implementation DrawView

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self.paths addObject:image];
    

    [self setNeedsDisplay];
}

// 撤销
- (void)undo
{
    [self.paths removeLastObject];
    
    [self setNeedsDisplay];
}
- (void)clear
{
    // 清除画板view所有的路径,并且重绘
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    _lineWidth = 1;
    _lineColor = [UIColor blackColor];
}

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

// 当手指点击view,就需要记录下起始点
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取UITouch
    UITouch *touch = [touches anyObject];
    
    // 获取起始点
    CGPoint curP = [touch locationInView:self];
    
    // 只要一开始触摸控件,设置起始点
    DrawPath *path = [DrawPath path];
    
    path.lineColor = _lineColor;

    [path moveToPoint:curP];

    
    path.lineWidth = _lineWidth;
    
    // 记录当前正在描述的路径
    _path = path;
    
    // 保存当前的路径
    [self.paths addObject:path];
}

// 每次手指移动的时候调用
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    // 获取UITouch
    UITouch *touch = [touches anyObject];
    
    // 获取当前触摸点
    CGPoint curP = [touch locationInView:self];
    
    [_path addLineToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
    
}

// 绘制东西
- (void)drawRect:(CGRect)rect
{
    for (DrawPath *path in self.paths) {
        
        if ([path isKindOfClass:[UIImage class]]) { // 图片
            UIImage *image = (UIImage *)path;
            
            [image drawAtPoint:CGPointZero];
        }else{
            
            [path.lineColor set];
            
            [path stroke];
        }
    }
}



@end
