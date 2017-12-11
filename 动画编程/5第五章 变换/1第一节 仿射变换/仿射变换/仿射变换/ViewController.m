//
//  ViewController.m
//  仿射变换
//
//  Created by 周泽文 on 16/7/21.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

/*
    没人能告诉你母体是什么，你只能自己体会——骇客帝国
 
    第四章视觉效果，了解了增强图层和其内容显示效果的一些技术，在本章中
    需要研究，对图层旋转、摆放、扭曲，属性是CGAffineTransform
    还可研究，把扁平物体转换成三维空间对象 ，属性是CATransform3D
 */


//创建 CGAffineTransform 实例
/***********************************
 1.CGAffineTransformMakeRotation（CGFloat angle）  // 旋转的仿射变换
 2.CGAffineTransformMakeScale（CGFloat sx,CGFloat sy） // 缩放的仿射变换
 3.CGAffineTransformMakeTranslation（CGFloat tx,CGFloat ty） //平移的仿射变换
 ***********************************/


// transform 属性
/***********************************
 1.UIView 可以通过 transform属性做变化，但只是封装了图层的变换
 2.CALayer 也有 transform 属性， 类型是 CATransform3D，不是CGAffineTransform
 CALayer 与 UIView.transform 对应的属性 是 affineTransform
 ***********************************/


// 混合变换
/***********************************
 Core Graphics 提供了三个函数，可以在一个变换的基础上，再做一次变换。
 如果你想做一个既有缩放又有旋转的变换，你可以先用上面的变换做 缩放或旋转
 然后在此基础上做 旋转或缩放
 下面三个函数可以实现这种效果
  CGAffineTransformRotate（CGAffineTransform t , CGFloat angle）// 基于一次变换的基础上做旋转
  CGAffineTransformScale（CGAffineTransform t , CGFloat sx , CGFloat sy）// 基于一次变换的基础上做缩放
  CGAffineTransformTranslate（CGAffineTransform t , CGFloat tx , CGFloat ty）// 基于一次变换的基础上做平移
 ***********************************/
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage * image = [UIImage imageNamed:@"Snowman"] ;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)] ;
    imageView.image = image ;
    
    // 将雪人图片 旋转 45°
    CGAffineTransform  rotationTransform = CGAffineTransformMakeRotation(M_PI_4) ;
    imageView.layer.affineTransform = rotationTransform ;
    [self.view addSubview:imageView] ;
    self.view.backgroundColor = [UIColor grayColor] ;
}



@end
