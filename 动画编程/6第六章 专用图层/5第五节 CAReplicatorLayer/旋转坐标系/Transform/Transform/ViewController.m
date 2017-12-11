//
//  ViewController.m
//  Transform
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
    CGRect  frame = CGRectMake(0, 0, 100, 100)  ;
    CGColorRef redColor = [UIColor redColor].CGColor ;
    CGColorRef blueColor = [UIColor blueColor].CGColor ;
    CGColorRef greenColor = [UIColor greenColor].CGColor ;
    CGColorRef purpleColor = [UIColor purpleColor].CGColor ;
    
    CALayer * layer1 = [CALayer layer] ;
    layer1.frame = frame ;
    layer1.backgroundColor = redColor ;
    [self.containerView.layer addSublayer:layer1] ;
    
    CATransform3D transform = CATransform3DIdentity ;
    transform = CATransform3DTranslate(transform, 0, 200, 0) ;
    
    CALayer * layer2 = [CALayer layer] ;
    layer2.frame = layer1.bounds ;
    layer2.transform = transform ;
    layer2.backgroundColor = blueColor ;
    [self.containerView.layer addSublayer:layer2] ;
    
    transform = CATransform3DRotate(transform, M_PI/5.0, 0, 0, 1) ;
    
    CALayer * layer3 = [CALayer layer] ;
//    layer3.frame = layer2.frame ;
    layer3.frame = layer2.bounds ;
//    layer3.frame = CGRectMake(layer2.frame.origin.x, layer2.frame.origin.y, 100, 100) ;
    layer3.backgroundColor = greenColor ;
    layer3.transform = transform ;
    [self.containerView.layer addSublayer:layer3] ;
    
    transform = CATransform3DTranslate(transform, 0, -200, 0) ;
    
    CALayer * layer4 = [CALayer layer] ;
//    layer4.frame = layer3.frame ;
    layer4.frame = layer3.bounds ;
//    layer4.frame = CGRectMake(layer3.frame.origin.x, layer3.frame.origin.y, 100, 100) ;
    layer4.backgroundColor = purpleColor ;
    layer4.transform = transform ;
    [self.containerView.layer addSublayer:layer4] ;
    NSLog(@"layer1.frame : %@",NSStringFromCGRect(layer1.frame)) ;
    NSLog(@"layer2.frame : %@",NSStringFromCGRect(layer2.frame)) ;
    NSLog(@"layer3.frame : %@",NSStringFromCGRect(layer3.frame)) ;
    NSLog(@"layer4.frame : %@",NSStringFromCGRect(layer4.frame)) ;
    NSLog(@"layer4.bounds : %@",NSStringFromCGRect(layer4.bounds)) ;
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//    CALayer * layer5 = [CALayer layer] ;
//    layer5.frame = CGRectMake(100, 200, 50, 50) ;
//    layer5.backgroundColor = [UIColor redColor].CGColor ;
//    [self.containerView.layer addSublayer:layer5] ;
//    
//    CATransform3D  transform2 = CATransform3DIdentity ;
//    transform2 = CATransform3DTranslate(transform2, 0, 100, 0) ; // 下移的距离是宽、高的两倍
//    transform2 = CATransform3DRotate(transform2, M_PI/5.0, 0, 0, 1) ;
//    transform2 = CATransform3DTranslate(transform2, 0, -100, 0) ;
//    
//    CALayer * layer6 = [CALayer layer] ;
//    layer6.frame = layer5.frame ;
//    layer6.transform = transform2 ;
//    layer6.backgroundColor = purpleColor ;
//    [self.containerView.layer addSublayer:layer6] ;
}

@end
