//
//  ViewController.m
//  CAAnimationGroup
//
//  Created by fox/周泽文 on 16/8/10.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


/*********************************************
 1.CABasicAnimation 和 CAKeyframeAnimation 都只作用于单独的属性
 2.CAAnimationGroup 可以组合动画，它是继承CAAnimation的子类
 animations数组属性,可以用来组合动画。
 *********************************************/
#import "ViewController.h"

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
    // 绘制 贝塞尔曲线路径
    UIBezierPath * bezierPath = [[UIBezierPath alloc] init] ;
    [bezierPath moveToPoint:CGPointMake(0, 150)] ;
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)] ;
    
    // 给曲线填色
    CAShapeLayer * pathLayer = [CAShapeLayer layer] ;
    pathLayer.path = bezierPath.CGPath ;
    pathLayer.fillColor = [UIColor clearColor].CGColor ;
    pathLayer.strokeColor = [UIColor redColor].CGColor ;
    pathLayer.lineWidth = 3.0f ;
    [self.containerView.layer addSublayer:pathLayer] ;
    
    // 创建 方块图层
    CALayer * colorLayer = [CALayer layer] ;
    colorLayer.frame = CGRectMake(0, 0, 64, 64) ;
    colorLayer.position = CGPointMake(0, 150) ;
    colorLayer.backgroundColor = [UIColor greenColor].CGColor ;
    [self.containerView.layer addSublayer:colorLayer] ;
    
    // 创建关键帧动画，路径
    CAKeyframeAnimation * animation1 = [CAKeyframeAnimation animation] ;
    animation1.keyPath = @"position" ;
    animation1.path = bezierPath.CGPath ;
    animation1.rotationMode = kCAAnimationRotateAuto ;
    
    // 创建渐变动画， 颜色
    CABasicAnimation * animation2 = [CABasicAnimation animation] ;
    animation2.keyPath = @"backgroundColor" ;
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor ;
    
    // 用路径 和 变色 创建动画组
    CAAnimationGroup * groupAnimation = [CAAnimationGroup animation] ;
    groupAnimation.animations = @[animation1, animation2] ;
    groupAnimation.duration = 4.0 ;
    
    // 给方块图层添加动画组
    [colorLayer addAnimation:groupAnimation forKey:nil] ;
    
}


@end
