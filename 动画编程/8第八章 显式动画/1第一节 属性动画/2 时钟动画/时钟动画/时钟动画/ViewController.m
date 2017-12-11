//
//  ViewController.m
//  时钟动画
//
//  Created by fox/周泽文 on 16/8/9.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

/*********************************************
 1.第三章图层几何学中，通过定时器简单更新每秒指针的角度来实现时钟动画。
 2.如果指针动态转向新的位置，会显得更加的真实。
 3.首先无法通过隐式动画来做，因为指针都是UIView的实例，默认禁用了隐式动画。
 所以可以通过UIView的动画方法来实现，但是如果想更好的控制动画的时间，显示动画更好。
 
 *********************************************/
//  bug1
/*********************************************
 1.先添加容器UIView，然后依次添加钟面、时、分、秒 四个UIImageView
 2.每添加一个就立刻设置好约束。
 3.将时、分、秒连线成为属性，依次设置动画
 4.启动程序之后，模拟器界面上值能看到钟面，时分秒 三个指针都不见了
 5.打开Reveal，发现 时分秒三个指针都在钟面的下面，被挡住了。
 6.但是视图的添加顺序，应该是钟面在下面。
 
 解决方案
 1 把时分秒的zPosition设置为大于0的值。
 2 用纯代码创建钟面、时、分、秒，依次添加到容器视图中。
 如果还出现这样的bug，只能使用方案一了。
 *********************************************/
//  bug2
/*********************************************
 1.秒钟动画时间是0.5秒，但是模拟器上显示的效果是
 当移动了1秒钟代表的弧度之后，会迅速返回上一秒的位置，
 然后瞬间回到下一秒的位置。
 
 2.第九章中将用fillMode属性来解决这个问题。
 *********************************************/
#import "ViewController.h"
#define AnchorPont_Y 0.95f // 锚点y值
#define ANIMATION_TIME 0.5f // 指针动画时间
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *clockFace;
@property (weak, nonatomic) IBOutlet UIImageView *hourHand;
@property (weak, nonatomic) IBOutlet UIImageView *minuteHand;
@property (weak, nonatomic) IBOutlet UIImageView *secondHand;
@property(nonatomic,strong) NSTimer * timer ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData] ;
}

-(void)initializeData
{
    // 设置锚点
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, AnchorPont_Y) ;
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, AnchorPont_Y) ;
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, AnchorPont_Y) ;
    
    // 因为时分秒三个指针被钟面挡住了，所以提高时分秒的zPosition
    self.secondHand.layer.zPosition = 1.0 ;
    self.minuteHand.layer.zPosition = 1.0 ;
    self.hourHand.layer.zPosition = 1.0 ;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES] ;

    [self updateHandsAnimation:NO] ;
}

-(void)tick
{
    [self updateHandsAnimation:YES] ;
}

-(void)updateHandsAnimation:(BOOL)animated
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSUInteger units = NSCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond ;
    NSDateComponents * components = [calendar components:units fromDate:[NSDate date]] ;
    CGFloat hourAngle = (components.hour/12.0) * M_PI*2.0 ;
    CGFloat minuteAngle = (components.minute/60.0)*M_PI*2.0 ;
    CGFloat secondAngle = (components.second/60.0)*M_PI*2.0 ;
    
    [self setAngle:hourAngle forHand:self.hourHand animated:animated] ;
    [self setAngle:minuteAngle forHand:self.minuteHand animated:animated] ;
    [self setAngle:secondAngle forHand:self.secondHand animated:animated] ;
}

-(void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated
{
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1) ;
    if (animated)
    {
        CABasicAnimation * animation = [CABasicAnimation animation] ;
        animation.keyPath = @"transform" ;
        // transform 是结构体类型，是基本数据类型不是引用数据类型
        // 而toValue虽然是id类型，但是必须是引用数据类型
        // 所以要对transform做封装 animation.toValue = transform ; 直接这样赋值是不行的
        animation.toValue = [NSValue valueWithCATransform3D:transform] ; // 封装
        animation.duration = ANIMATION_TIME ;
        animation.delegate = self ;
        [animation setValue:handView forKey:@"handView"] ; // 利用KVC的方式赋值
        [handView.layer addAnimation:animation forKey:nil] ;
    }
    else
    {
        handView.layer.transform = transform ;
    }
}

-(void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    UIView * handView = [anim valueForKey:@"handView"] ;// 利用KVC的方式取值
    handView.layer.transform = [anim.toValue CATransform3DValue] ; // 解封
    
}
@end
