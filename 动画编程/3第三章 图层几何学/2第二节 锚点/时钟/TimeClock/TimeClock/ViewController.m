//
//  ViewController.m
//  TimeClock
//
//  Created by 周泽文 on 16/7/25.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

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
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.95f) ;
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.95f) ;
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.95f) ;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                            selector:@selector(tick)
                                            userInfo:nil
                                            repeats:YES] ;
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
