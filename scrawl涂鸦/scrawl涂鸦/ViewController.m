//
//  ViewController.m
//  10-涂鸦画板
//
//  Created by 陈弘根 on 15/8/4.
//  Copyright (c) 2015年 陈弘根. All rights reserved.
//

#import "ViewController.h"

#import "DrawView.h"

#import "MBProgressHUD+XMG.h"

#import "HandleImageView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HandleImageViewDelegate>

@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController
// 清屏
- (IBAction)clear:(id)sender {
        
    [_drawView clear];
    
}
- (IBAction)undo:(id)sender {
    
    [_drawView undo];
    
}
- (IBAction)eraser:(id)sender {
    
    _drawView.lineColor = [UIColor whiteColor];
    
}

// 选择照片
- (IBAction)pickerPhotot:(id)sender {
    
    // 进入系统的相册
    // 照片选择控制器
    UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
    
    imagePickerVc.delegate = self;
    
    imagePickerVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
// 只要用户选择了照片就会调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取选择的照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 对选择的照片需要做一些处理,平移,缩放,旋转
    HandleImageView *handleImageV = [[HandleImageView alloc] initWithFrame:_drawView.bounds];
    
    handleImageV.delegate = self;
    
    handleImageV.image = image;
    
    [_drawView addSubview:handleImageV];
    
    
    // 绘制到画板上
//    _drawView.image = image;
    
    
    // 退出选择界面
    // modal出谁,谁就能dismiss
    // 谁Modal,谁就能dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma HandleImageViewDelegate
// 当处理完图片的时候调用
- (void)handleImageView:(HandleImageView *)handleImageView didHandleImage:(UIImage *)image
{
    _drawView.image = image;
}


- (IBAction)save:(id)sender {
    // 把绘制的图形保存到相册
    
    // 相册里面保存的是UIImage
    
    // 需要把绘制的内容生成一张图片
    
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
    
    // 取出画板view的layer
    CALayer *layer = _drawView.layer;
    
    // 渲染上下文
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 从上下文中取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    // 保存到相册里
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

// 保存完成的时候回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存失败"];
    }else{
        [MBProgressHUD showSuccess:@"保存成功"];
    }
}

// 点击颜色色块的时候调用
- (IBAction)clickColor:(UIButton *)sender {
    
    // 设置绘制线条的颜色
    _drawView.lineColor = sender.backgroundColor;
}

// 每次拖动滑条的时候调用
- (IBAction)lineWidthChange:(UISlider *)sender {

    _drawView.lineWidth = sender.value;
    
}


@end
