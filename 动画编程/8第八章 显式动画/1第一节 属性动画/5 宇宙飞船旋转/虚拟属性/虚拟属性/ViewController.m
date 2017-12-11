//
//  ViewController.m
//  虚拟属性
//
//  Created by fox/周泽文 on 16/8/10.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//
//  虚拟属性
/*********************************************
 1.属性动画实际上是针对关键路径，而不是一个键。
 这意味着可以对子属性甚至虚拟属性做动画。
 
 2.如果想要对一个物体做旋转动画，就需要用到transform属性，
 因为CALayer没有提供角度或者方向之类的属性。可以使用CABasicAnimation的toValue属性来做
 但是若独立于角度之外，还需要做平移或者缩放动画呢？
 我们都需要修改transform属性，实时计算每个时间点每个变换效果，然后根据这些
 创建一个复杂的关键帧动画，这样做的目的仅仅是对图层做一个简单的动画。
 
 3.苹果提供了更好的解决方案
 对图层的旋转，可以用transform.rotation关键路径应用动画，而不是transform本身
 这样的好处有很多
 1 可以不通过关键帧一步旋转大于180°的动画
 2 可以用相对值而不是绝对值旋转(byValue代替toValue)
 3 不需要创建CATransform3D，仅仅是用简单的数值@(M_PI * 3) 来指定角度
 4 不会和transform.position 或 transform.scale冲突
 
 4.transfrom.rotation 是什么?
 CATransform3D不是一个对象，它是一个结构体，也没有KVC相关的属性。
 transform.rotation实际上是一个CALayer用于处理动画变换的虚拟属性。
 
 
 5.不可以直接设置transform.rotation或transform.scale等虚拟属性，它们不能被直接使用。
 当你对这些虚拟属性做动画的时候，Core Animation会自动根据CAValueFunction来计算更新transform属性
 CAValueFunction用于把赋值给虚拟属性的浮点值转换成真正用于摆放图层的CATransform3D矩阵值。
 可以设置CAPropertAnimation的valueFunction属性来改变。
 
 6CAValueFunction 看起来是对那些无法简单相加的属性(如矩阵变换)做动画的非常有用的机制
 但CAVlueFuction的实现是私有的，目前无法通过继承来自定义。
 可以通过苹果提供的常量(目前都是和矩阵变换的虚拟属性相关，所以使用的场景不多，这些属性都有了默认的实现方式。)
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
    // 初始化飞船图层
    CALayer * shipLayer = [CALayer layer] ;
    shipLayer.frame = CGRectMake(0, 0, 128, 128) ;
    shipLayer.position = CGPointMake(150, 150) ;
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"Ship"].CGImage ;
    [self.containerView.layer addSublayer:shipLayer] ;
    
    CABasicAnimation * animation = [CABasicAnimation animation] ;
//    animation.keyPath = @"transform" ;
//    animation.toValue =[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)] ;
    animation.keyPath = @"transform.rotation" ;  // 设置虚拟属性
    animation.byValue = @(M_PI * 3) ;
    
     animation.duration = ANIMATION_TIME ;
    [shipLayer addAnimation:animation forKey:nil] ;
    
}

@end
