//
//  ViewController.m
//  CAShapeLayer 和 UIBezierPath
//
//  Created by fox/周泽文 on 16/7/14.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


//  CAShapeLayer 简介
/*********************************************
 CAShapeLayer 是一个通过矢量图而不是bitmap来绘制图层的layer子类
 指定 如颜色和线宽等属性，用CGPath来定义需要的形状，用CAShapeLayer
 就能自动渲染出来。也可以用Core Graphics直接向原始的CALayer的内容绘
 制一个路径。
 CAShapeLayer的优点
 1.渲染快速： CAShapeLayer 使用了硬件加速，绘制相同的图形比Core Graphics快
 2.低耗内存： CAShapeLayer 不用和普通的CALayer一样创建寄宿图；因此无论多大，
 都不会占用太多的内存。
 3.不裁边界： CAShapeLayer 可在边界之外绘制，图层路径不会像Core Graphics的
 普通CAlayer一样被裁剪掉。
 4.无像素化： CAShapeLayer 做3D变换时，不会像有寄宿图的普通图层一样像素化。
 *********************************************/

//    CAShapeLayer 需要控制的属性
/*********************************************
 1.CAShapeLayer 可以绘制所有能够通过CGPath来表示的形状，形状可以不闭合
 图层路径不一定要牢不可破，能在一个图层上绘制好几个不同的形状。
 2. LineWith 线宽 点表示
   LineCap 线尾
   LineJoin 线交点
 *********************************************/

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CAShapeLayer使用" ;
    
    [self strokeMatchstickMen] ; // 绘制火柴人
    
    [self strokeRoundRectangle] ; // 绘制 圆角矩形
    
    
}

-(void)strokeMatchstickMen
{
    // 绘制 火柴人
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    // create path
    UIBezierPath *path = [[UIBezierPath alloc]init] ;
    [path moveToPoint:CGPointMake(175, 100)] ;
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES] ;
    [path moveToPoint:CGPointMake(150, 125)] ;
    [path addLineToPoint:CGPointMake(150, 175)] ;
    [path addLineToPoint:CGPointMake(125, 225)] ;
    [path moveToPoint:CGPointMake(150, 175)] ;
    [path addLineToPoint:CGPointMake(175, 225)] ;
    [path moveToPoint:CGPointMake(100, 150)] ;
    [path addLineToPoint:CGPointMake(200, 150)] ;
    
    // create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer] ;
    shapeLayer.strokeColor = [UIColor redColor].CGColor ;
    shapeLayer.fillColor = [UIColor clearColor].CGColor ;
    shapeLayer.lineWidth = 5 ;
    shapeLayer.lineJoin = kCALineJoinRound ;
    shapeLayer.lineCap = kCALineCapRound ;
    shapeLayer.path = path.CGPath ;
    
    // add it to our view
    [self.view.layer addSublayer:shapeLayer] ;
}

-(void)strokeRoundRectangle
{
    // 圆角矩形
    //创建圆角矩形，其实就是单独绘制 直线和弧度
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    //  绘制圆角矩形的几种办法
    /*********************************************
     1.CAlayer的cornerRadius 属性 所有的角都会变成圆角
     2.CAShapeLayer 比CAlayer麻烦，但是可以单独指定角
     3.UIBezierPah
     *********************************************/
    
    // define path parameters
    CGRect rect = CGRectMake(100, 300, 100, 100) ;
    CGSize radii = CGSizeMake(20, 20) ;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft ; // 三个圆角
    // create path
    UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii] ;
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer] ;
    shapeLayer2.strokeColor = [UIColor cyanColor].CGColor ;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor ;
    shapeLayer2.lineWidth = 5 ;
    shapeLayer2.lineJoin = kCALineJoinRound ;
    shapeLayer2.lineCap = kCALineCapRound ;
    shapeLayer2.path = path2.CGPath ;
    [self.view.layer addSublayer:shapeLayer2] ;
}
@end
