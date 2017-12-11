//
//  ViewController.m
//  颜色渐变
//
//  Created by fox/周泽文 on 16/8/9.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  关键帧
/*********************************************
 1.计算机动画术语，帧——动画中最小单位的单幅影像画面，即电影胶片上的每格镜头。
 动画软件的时间轴上，帧表示为一格或一格标记。
 2.关键帧——相当于二位动画中的原画，指物体变化关键处的那一帧
 关键帧之间的动画可以由软件来创建，成为过渡帧或中间帧。
 *********************************************/

//  CAKeyframeAnimation
/*********************************************
 1.CABasicAnimation揭示了大多隐式动画背后的机制，但显式地给
 图层添加CABasicAnimation和隐式动画比较，费力不讨好。
 
 2.CAKeyframeAnimation是另一种UIKit没有暴露出来的类，
 与CABasicAnimation类似，两者都是CAPropertyAnimation的子类，
 都作用于单一的一个属性。
 不同点是CAKeyframeAnimation不限制于设置一个起始和结束值
 CAKeyframeAnimation可以根据一连串随意的值来做动画
 
 CAKeyframeAnimation提供关键帧，Core Animation在每帧之间插入过渡帧。
 *********************************************/


/*********************************************
 1.因为CAKeyframeAnimation不能自动把图层的初始值当做第一帧
 动画开始的时候，会从初始值跳变到第一帧；在结束的时候，突然从最后一帧跳变到初始值。
 
 2.所以为了动画平滑的特性，一般会把CAKeyframeAnimation的第一帧和最后一帧
 都设置为初始值。
 
 3.如果想创建一个开始和结束不同的动画，
 首先第一帧和最后一帧要不同
其次 属性值应该和第一帧一样，
 再者在动画启动前将属性值改为和最后一帧相同
 进过这样三步就能得到开始和结束不同的动画，也保持了平滑的动画特性
 
 4.动画始终以一个恒定的步调在运行，每个动画之间过渡的时候并没有减速
 为了让动画看起来更加自然，需要调整一下缓冲，第十章将会涉及。
 *********************************************/
#import "ViewController.h"
#define ANIMATION_TIME 3.0
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) CALayer * colorLayer ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData] ;
}

-(void)initializeData
{
    self.colorLayer = [CALayer layer] ;
    self.colorLayer.frame = CGRectMake(50, 50, 200, 200) ;
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor ;// 图层颜色的初始值为 蓝色
    // 若果将图层的初始值 设置为 蓝绿色，那么动画的开始和结束都会有突变的效果。
//    self.colorLayer.backgroundColor = [UIColor cyanColor].CGColor ;
    [self.containerView.layer addSublayer:self.colorLayer] ;
    
    self.containerView.backgroundColor = [UIColor grayColor] ;
}

- (IBAction)changeColor:(id)sender {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation] ;
    animation.keyPath = @"backgroundColor" ;
    animation.duration = ANIMATION_TIME ;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor, //第一帧
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor cyanColor].CGColor] ;// 最后一帧
    self.colorLayer.backgroundColor = [UIColor cyanColor].CGColor ; // 手动将初始值改变和最后一帧相同
    [self.colorLayer addAnimation:animation forKey:nil] ;
}



@end
