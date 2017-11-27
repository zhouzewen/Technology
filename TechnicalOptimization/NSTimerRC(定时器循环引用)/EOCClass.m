//
//  EOCClass.m
//  NSTimerRetainCycle
//
//  Created by 周泽文 on 2017/7/22.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "EOCClass.h"
#import "NSTimer+EOCBlockSupport.h"
@implementation EOCClass{
    NSTimer *_pollTimer;
}
-(instancetype)init{
    return [super init];
}
-(void)dealloc{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    [_pollTimer invalidate];
}
-(void)startPolling{
//    _pollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
//                                                  target:self
//                                                selector:@selector(p_dopoll)
//                                                userInfo:nil
//                                                 repeats:YES];
    
//    __weak EOCClass * weakSelf = self;
//    __weak typeof(self) weakSelf = self;
    _pollTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:2.0
                                                       block:^{
//                                                           EOCClass * strongSelf = weakSelf;
//                                                                [strongSelf p_dopoll];
//                                                           [weakSelf p_dopoll];
                                                           [self p_dopoll];
                                                              }
                                                     repeats:YES];
}
-(void)stopPolling{
    [_pollTimer invalidate];
    _pollTimer = nil;
}
-(void)p_dopoll{
    // poll the resource
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
@end
