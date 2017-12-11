//
//  ViewController.m
//  多重对角线颜色渐变
//
//  Created by 周泽文 on 16/7/31.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

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
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor , (__bridge id)[UIColor blueColor].CGColor , (__bridge id)[UIColor greenColor].CGColor] ;
    gradientLayer.locations = @[@0.0,@0.5,@1.0] ;
    
    gradientLayer.startPoint = CGPointMake(0, 0) ;
    gradientLayer.endPoint = CGPointMake(1, 1) ;
    
}


@end
