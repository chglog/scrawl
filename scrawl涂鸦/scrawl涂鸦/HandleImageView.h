//
//  HandleImageView.h
//  10-涂鸦画板
//
//  Created by 陈弘根 on 15/8/7.
//  Copyright (c) 2015年 陈弘根. All rights reserved.
//  处理图片

#import <UIKit/UIKit.h>

@class HandleImageView;

@protocol HandleImageViewDelegate <NSObject>

@optional
- (void)handleImageView:(HandleImageView *)handleImageView didHandleImage:(UIImage *)image;

@end

@interface HandleImageView : UIView

@property (nonatomic, strong) UIImage *image;


@property (nonatomic, weak) id<HandleImageViewDelegate> delegate;

@end
