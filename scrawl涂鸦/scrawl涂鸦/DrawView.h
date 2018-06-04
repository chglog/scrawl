//
//  DrawView.h
//  10-涂鸦画板
//
//  Created by 陈弘根 on 15/8/4.
//  Copyright (c) 2015年 陈弘根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic, assign) CGFloat lineWidth;

// 线段的颜色
@property (nonatomic, strong) UIColor *lineColor;

// 获取选中的照片
@property (nonatomic, strong) UIImage *image;

// 清屏
- (void)clear;

// 撤销
- (void)undo;

@end
