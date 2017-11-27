//
//  HWWeakTimerTarget.m
//  NSTimerRetainCycle
//
//  Created by 周泽文 on 2017/7/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "HWWeakTimerTarget.h"
@implementation HWWeakTimerTarget
-(void)fire:(NSTimer *)timer{
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer.userInfo];
    }else{
        [self.timer invalidate];
    }
}
+(NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    target:(id)aTarget
                                  selector:(SEL)aSelector
                                  userInfo:(id)userInfo
                                   repeats:(BOOL)repeats
{
    HWWeakTimerTarget * timerTarget = [[HWWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(fire:)
                                                       userInfo:userInfo
                                                        repeats:repeats
                         ];
    return timerTarget.timer;
}
@end
