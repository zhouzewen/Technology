//
//  ViewController.m
//  RemoveAnimation
//
//  Created by fox/周泽文 on 16/8/13.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


/*********************************************
 1.-AddAnimation：forKey: 参数key可以用来在检索一个动画
 但是不支持在动画运行时修改动画。此方法主要用来检测动画的属性
 或者判断动画是否被添加到当前图层中。
 
 2.终止一个指定的动画
 -(void)removeAnimationFokKey:(NSString *)Key ;
 
 3.移除所有动画
 -(void)removeAllAnimations ;
 
 4.动画一旦被移除，图层的外观立刻回更新到当前模型图层的值。
 一般动画在结束后会被自动移除，除非设置removeOnCompletion为NO
 若要设置动画在结束之后不被自动移除，那么当必须在不需要的时候手动移除
 否则会一直占用内存，直到图层被销毁。
 
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic ,weak) CALayer * shipLayer ;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor] ;
    self.containerView.backgroundColor = [UIColor grayColor] ;
    
    // 设置宇宙飞船layer
    self.shipLayer = [CALayer layer] ;
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128) ;
    self.shipLayer.position = CGPointMake(150, 150) ;
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"Ship"].CGImage ;
    [self.containerView.layer addSublayer:self.shipLayer] ;
}

- (IBAction)startAnimation:(id)sender
{
    CABasicAnimation * animation = [CABasicAnimation animation] ;
    animation.keyPath = @"transform.rotation" ;
    animation.duration = 2.0 ;
    animation.byValue = @(M_PI * 2) ;
    animation.delegate = self ;
    // 这里 key 不再赋值为nil，给一个指定的key 来标识这个动画
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"] ;
    
}

- (IBAction)stopAnimation:(id)sender
{
    // 根据上面指定的key 找到对应的动画， 移除动画
    [self.shipLayer removeAnimationForKey:@"rotateAnimation"] ;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"The animation stopped (finished:%@)",flag ? @"YES" : @"NO") ;
}
@end
