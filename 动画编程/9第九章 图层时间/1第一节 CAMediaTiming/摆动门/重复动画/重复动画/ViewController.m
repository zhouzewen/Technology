//
//  ViewController.m
//  重复动画
//
//  Created by fox/周泽文 on 16/8/15.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  重复动画
/*********************************************
 1.第一种创建方式
 设置重复的次数，和单次动画持续的时间。
 
 2.第二种创建方式
 设置重复动画的时间，
 
 3.repeatCount 和 repeatDuration 只需要对其中一个值设置为非零
 对两个值都设置非零值的动画没有被定义。
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
    CALayer * doorLayer = [CALayer layer] ;
    doorLayer.frame = CGRectMake(0, 0, 128, 256) ;
    doorLayer.position = CGPointMake(150 - 64, 150) ;
    doorLayer.anchorPoint = CGPointMake(0, 0.5) ; // 设置锚点
    doorLayer.contents = (__bridge id)[UIImage imageNamed:@"Door"].CGImage ;
    [self.containerView.layer addSublayer:doorLayer] ;
    
    CATransform3D perspective = CATransform3DIdentity ;
    perspective.m34 = -1.0/500.0 ;
    self.containerView.layer.sublayerTransform = perspective ;
    
    CABasicAnimation * animation = [CABasicAnimation animation] ;
    animation.keyPath = @"transform.rotation.y" ;
    animation.toValue = @(-M_PI_2) ;
    animation.duration = 2.0 ; // 打开门的动画持续的时间是2.0
//    animation.repeatDuration = INFINITY ;//重复动画的持续时间是  无限
    animation.repeatDuration = 5.0 ;
    animation.autoreverses = YES ;// 动画完成后，自动回到动画的初始状态
    [doorLayer addAnimation:animation forKey:nil] ;
}

@end
