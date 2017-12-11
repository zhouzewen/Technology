//
//  ViewController.m
//  RotationSnapshot
//
//  Created by fox/周泽文 on 16/8/13.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


/*********************************************
 1.过渡动画的基础原则是对原始图层外观截图，然后添加一段动画，
 平滑过渡到图层改变之后那个截图的效果。
 
 2.若知道如何截图，就可以使用属性动画来代替CATransition
 或者用UIKit的过渡方法来实现动画。
 
 3.CALayer的方法-renderInContext：可以通过把它绘制到Core Graphics的上下文中
 捕获当前内容的图片，然后在另外的视图中显示出来。
 若把截图置于原始视图上，就可以遮盖真实视图的变化。
 
 4. -renderInContext： 捕获了图层的图片和子图层，但是无法对子图层正确
 处理变换效果，而且对视频和OpenGL内容也不起作用。
 但是CATransiton 或 私有截屏方式 是没有这个限制的。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 旋转+缩小 屏幕截图 ，背景色渐变 淡入淡出
- (IBAction)performTransiton:(UIButton *)sender {
    
    // 设置截图的尺寸  是否透明(yes不透明)  缩放尺寸
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0) ;
    // 利用CALayer 方法 捕获 图层的图片
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()] ;
    // 拿到这个图片——即截图
    UIImage * coverImage = UIGraphicsGetImageFromCurrentImageContext() ;
    
    // 根据截图图片，创建 视图 并添加到 self.view上
    UIView * coverView = [[UIImageView alloc] initWithImage:coverImage] ;
    coverView.frame = self.view.bounds ;
    [self.view addSubview:coverView] ;
    
    // 设置self.view 背景色
    CGFloat red = arc4random()/(CGFloat)INT_MAX ;
    CGFloat green = arc4random()/(CGFloat)INT_MAX ;
    CGFloat blue = arc4random()/(CGFloat)INT_MAX ;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0] ;
    
    // 使用UIView动画
    [UIView animateWithDuration:1.0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01) ; // 放射变换—— 缩放
        transform = CGAffineTransformRotate(transform, M_PI_2) ; // 放射变换——旋转(在上一个变换的基础上)
        coverView.transform = transform ;
        coverView.alpha = 0.0 ;
    } completion:^(BOOL finished) {// 动画完成时的操作
        [coverView removeFromSuperview] ; // 将 coverView 移除
    }] ;
    
}


@end
