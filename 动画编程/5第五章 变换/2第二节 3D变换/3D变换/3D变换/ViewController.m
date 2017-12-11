//
//  ViewController.m
//  3D变换
//
//  Created by 周泽文 on 16/7/22.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//


//3D变换
/***********************************
 CG的前缀，说明CGAffineTransform类型属于 Core Graphics框架，CoreGraphics是2D绘图框架
 CGAffineTransform 仅仅对2D变换有效
 2.图层的 transform属性是 CATransform3D类型，能够实现图层在3D空间内移动或旋转
 CATransform3D 是一个 4X4矩阵
 3 CA开头，Core Animation 框架 提供了一系列方法，用来创建和组合CATransform3D
 CATransform3DMakeRotation（CGFloat angle , CGFloat x , CGFloat y , CGFloat z）  旋转
 CATransform3DMakeScale（CGFloat sx , CGFloat sy , CGFloat sz） 缩放
 CATransform3DMakeTranslation（CGFloat tx , CGFloat ty , CGFloat tz） 平移
 ***********************************/


//灭点
/***********************************
 透视角度绘图时，远离相机角度的物体会变小、变远。极限情况下，所有物体都会消失在一个点上——灭点

 为了在应用中创建 拟真效果的透视，这个点应该在屏幕中间，或包含所有3D对象的视图中点。
 Core Animation 定义的灭点在图层的anchorPoint上。当图层发生变换时，灭点永远位于图层变换前anchorPoint位置。
 如果 改变了一个图层的 position ，那么anchorPoint会改变，灭点也随之改变。
 当视图通过调整m34显得更加具有3D效果时，应该先把anchorPoint放在屏幕中点，然后通过平移把灭点移动到
 指定位置，这样所有的3D图层都共享一个灭点。
 ***********************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *originView;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIView *layerView2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rotationLayerView1] ;
    [self rotationLayerView2] ;
}
-(void)rotationLayerView1
{
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0) ;
    self.layerView.layer.transform = transform ;
}
-(void)rotationLayerView2
{
    CATransform3D transform = CATransform3DIdentity ;
    transform.m34 = -1.0/500.0 ;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0) ;
    self.layerView2.layer.transform = transform  ;
}

@end
