//
//  ViewController.m
//  图层颜色改变动画
//
//  Created by fox/周泽文 on 16/8/4.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

/*********************************************
 1.Core Animation 基于一个假设 ：屏幕上的任何东西都可以做动画。
 动画并不需要在Core Animation中手动打开，相反需要明确是否关闭，否则会一直开启。
 
 2.改变CALayer可以做动画的属性，屏幕上不会立即体现。而是一个渐变的过程，默认
 时间是0.25秒。—— 隐式动画
 
 3.之所以成为隐式动画的原因，是我们没有指定任何动画类型，仅仅改变了一个属性。
 Core Animation决定 何时 何种方式 做动画。
 
 4.Core Animation 如何判断 动画的类型 和 动画持续时间呢？
 动画的类型取决于 图层的行为
 动画的时间取决于 事务的设置
 
 5. 什么是事务？
 事务是Core Animation用来包含一系列属性动画集合的机制，任何指定事务去改变可以
 做动画的图层属性，都不会瞬时改变，而是当事务提交的时候开始动画过渡到新值。
 
 iOS 负责收集用户输入、处理定时器或者网络事件，开始重绘屏幕都是Run Loop处理的。
 Core Animation在每个Run Loop 周期中，会自动开始一次新的事务，任何在这个周期中
 属性的改变，都会被集中起来做一次0.25秒的动画。
 
 6.CATransaction
 事务通过 CATransaction类 来管理，这个类没有属性，也没有实例方法。
 也不能通过+alloc -init去创建。 但可以用 +begain +commit 来入栈和出栈。
 任何可以做动画的图层属性，都会被添加到一个栈的栈顶。这个栈是专门用来存放事务的。
 
 修改动画时间之前，需要新建一个事务，这样就能避免因为修改当前事务时影响到
 同一时刻别的动画。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,weak) CALayer * colorLayer ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData] ;
}

-(void)initializeData
{
    self.view.backgroundColor = [UIColor grayColor] ;
    
    self.colorLayer  = [CALayer layer] ;
    self.colorLayer.frame = CGRectMake(50, 50, 200, 200) ;
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor ;
    [self.containerView.layer addSublayer:self.colorLayer] ;
}

- (IBAction)changeColor:(id)sender
{
    [CATransaction begin] ; //开始一个新的事务
    [CATransaction setAnimationDuration:3.0] ; // 设置隐式动画的时间
    
    [CATransaction setCompletionBlock:^{  // 设置事务 完成后的完成动作
        [CATransaction setAnimationDuration:1.0] ; // 默认是 0.25秒 这里修改为 1秒
        CGAffineTransform transform = self.colorLayer.affineTransform ;
        transform = CGAffineTransformRotate(transform, M_PI_2) ; // 旋转90°
        self.colorLayer.affineTransform = transform ;
    }] ;
    
    CGFloat red = arc4random()/(CGFloat)INT_MAX ;
    CGFloat green = arc4random()/(CGFloat)INT_MAX ;
    CGFloat blue = arc4random()/(CGFloat)INT_MAX ;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor ;
    
    [CATransaction commit] ;
}

@end
