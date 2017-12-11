//
//  ViewController.m
//  推进过渡
//
//  Created by fox/周泽文 on 16/8/4.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


/*********************************************
 改变属性时 CALayer自动应用的动画称为行为。
 行为通常是一个被 Core Animation隐式调用的显示动画对象
 
 *********************************************/

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic ,weak) CALayer * colorLayer ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;
}

-(void)initializeData
{
    self.view.backgroundColor = [UIColor grayColor] ;
    
    self.colorLayer = [CALayer layer] ;
    self.colorLayer.frame = CGRectMake(50, 50, 200, 200) ;
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor ;
    
    CATransition * transition = [CATransition animation] ;
    transition.type = kCATransitionPush ; // 推出
//    transition.type = kCATransitionReveal ;
//    transition.type = kCATransitionFade ;
//    transition.type = kCATransitionMoveIn ;
    transition.subtype = kCATransitionFromLeft ; // 从左侧滑入
    self.colorLayer.actions = @{@"backgroundColor" : transition} ;
    [self.containerView.layer addSublayer:self.colorLayer] ;
    
}

- (IBAction)changeColor:(id)sender {
    [CATransaction begin] ;
    [CATransaction setAnimationDuration:1.0] ;
    
    CGFloat red = arc4random()/(CGFloat)INT_MAX ;
    CGFloat blue = arc4random()/(CGFloat)INT_MAX ;
    CGFloat green = arc4random()/(CGFloat)INT_MAX ;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor ;
    [CATransaction commit] ;
}
@end
