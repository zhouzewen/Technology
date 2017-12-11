//
//  ViewController.m
//  动画计时
//
//  Created by fox/周泽文 on 16/8/13.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


/*********************************************
 1.动画的发生时需要持续一段时间的，所以计时对动画来说很重要。
 
 2.Core Animation是如何跟踪时间的呢？
 
 3.CAMediaTiming协议定了在一段动画内，失去时间的属性集合。
 CALayer和CAAnimation都实现了这个协议，时间可以被任意基于
 一个图层或者一段动画的类控制。
 
 4.上一章显示动画中，有动画的duration。它是CFTimeInterval类型(CAMediaTiming属性之一),对要进行的动画，指定了持续时间。
 
 5.动画的迭代
 CAMediaTiming还有一个属性repeatCount 代表动画重复的次数，如果duration是2
 repeatCount为3，那么完整的动画时长是6秒。repeatCount是浮点类型的数
 
 6. 默认情况下 du
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatCountTextField;

@property (weak, nonatomic) CALayer * shipLayer ;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor] ;
    self.containerView.backgroundColor = [UIColor grayColor] ;
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(100, 100);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"Ship.png"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
}

-(void)setControlsEnabled:(BOOL)enabled
{
    for (UIControl * control in @[self.durationTextField,self.repeatCountTextField,self.startButton])
    {
        control.enabled = enabled ;
        control.alpha = enabled ? 1.0f : 0.25f ;
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.durationTextField resignFirstResponder] ;
    [self.repeatCountTextField resignFirstResponder] ;
    
}


- (IBAction)startAnimation:(id)sender
{
    CFTimeInterval durantion = [self.durationTextField.text doubleValue] ;
    float repeatCount = [self.repeatCountTextField.text floatValue] ;
    
    CABasicAnimation * animation = [CABasicAnimation animation] ;
    animation.keyPath = @"transform.rotation" ;
    animation.duration = durantion ;
    animation.repeatCount = repeatCount ;
    animation.byValue = @(M_PI * 2) ;
    animation.delegate = self ;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"] ;
    
    [self setControlsEnabled:NO] ;

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self setControlsEnabled:YES] ;
}

@end
