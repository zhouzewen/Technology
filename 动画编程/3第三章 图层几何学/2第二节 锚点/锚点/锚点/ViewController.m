//
//  ViewController.m
//  锚点
//
//  Created by fox/周泽文 on 16/7/16.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


//  锚点 anchorPoint
/*********************************************
 1.控制图层position的点，默认在图层的中心（0.5,0.5）
 2.anchorPoint 属性没有被 UIView的接口暴露.
 3. anchorPoint可以移动，如果把(0.5,0.5) 改为(0，0)，图层的内容会向右下移动，不再居中
 4. anchorPoint的值可以大于1，或者小于0
 *********************************************/

//  锚点 anchorPoint 的作用
/*********************************************
 1.anchorPoint是旋转的中心点
 2.时钟指针旋转的时候，需要将锚点移动到指针的尾部
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hourHand;
@property (weak, nonatomic) IBOutlet UIImageView *minuteHand;
@property (weak, nonatomic) IBOutlet UIImageView *secondHand;
@property (nonatomic,strong) NSTimer * timer ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES] ;
    [self tick] ;
}

-(void)tick
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond ;
    NSDateComponents * components = [calendar components:units fromDate:[NSDate date]] ;
    CGFloat hoursAngle = (components.hour/12.0)*M_PI*2.0 ;
    CGFloat minsAngle = (components.minute/60.0)*M_PI*2.0 ;
    CGFloat secsAngle = (components.second/60.0)*M_PI*2.0 ;
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle) ;
    self.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle) ;
    self.secondHand.transform = CGAffineTransformMakeRotation(secsAngle) ;
    
}


@end
