//
//  ViewController.m
//  颜色渐变
//
//  Created by 周泽文 on 16/7/31.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

//CAGradientLayer
/***********************************
 1.CAGradientLayer  绘制的时候使用了硬件加速
 2.CAGradientLayer 可以生成两种或者更多颜色的平滑渐变
 ***********************************/

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
    CAGradientLayer * gradientLayer = [CAGradientLayer layer] ;
    gradientLayer.frame = self.containerView.bounds ;
    [self.containerView.layer addSublayer:gradientLayer] ;
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor blueColor].CGColor] ;
    gradientLayer.startPoint = CGPointMake(0, 0) ; // 颜色渐变的起点
    gradientLayer.endPoint = CGPointMake(0.5, 0.5) ; // 颜色渐变的终点
}

@end
