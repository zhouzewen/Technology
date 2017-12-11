//
//  ViewController.m
//  CGPath绘制动画路径
//
//  Created by fox/周泽文 on 16/8/9.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


/*********************************************
 1.提供一个值的数组，颜色的动画就可以按照这些值来做。但一般来不会这样。
 
 2.CAKeyframeAnimation还有另外一种方式指定动画：CGPath，使用CGPath更加直观。
 
 3.为了创建路径，需要使用一个三次贝塞尔曲线。它是一种使用开始点和结束点
 以及两个控制点，共四个点来定义形状的曲线。可以通过使用基于C的Core Graphics绘图指令
 来创建，不过UIKit提供了UIZeierPath类更简单。
 
 4.飞船运动的时候，一直都是指向右边的，不合理。可以通过调整affineTransform
 对运动方向做动画，但很可能和其他动画冲突。
KAKeyframeAnimation有一个rotationMode属性，当把属性的值设置为KCAAnimationRotateAuto时
 图层会根据曲线切线的方向自动旋转。
 *********************************************/
#import "ViewController.h"
#define ANIMATION_TIME 4.0
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData] ;
}

-(void)initializeData
{
    // 绘制曲线路径
    UIBezierPath * bezierPaht = [[UIBezierPath alloc] init] ;
    [bezierPaht moveToPoint:CGPointMake(0, 150)] ;
    [bezierPaht addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)] ;
    
    // 给曲线添着色 并添加到容器视图上
    CAShapeLayer * pathLayer = [CAShapeLayer layer] ;
    pathLayer.path = bezierPaht.CGPath ;
    pathLayer.fillColor = [UIColor clearColor].CGColor ;
    pathLayer.strokeColor = [UIColor redColor] .CGColor ;
    [self.containerView.layer addSublayer:pathLayer] ;
    
    // 创建飞船
    CALayer * shipLayer = [CALayer layer] ;
    shipLayer.frame = CGRectMake(0, 0, 64, 64) ;
    shipLayer.position = CGPointMake(0, 150) ;
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"Ship"].CGImage ;
    [self.containerView.layer addSublayer:shipLayer] ;
    
    // 设置动画
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation] ;
    animation.keyPath = @"position" ;
    animation.duration = ANIMATION_TIME ;
    animation.path = bezierPaht.CGPath ;
    animation.rotationMode = kCAAnimationRotateAuto ; // 让飞船沿着曲线切线的方向运动
    [shipLayer addAnimation:animation forKey:nil] ;
    
}

@end
