//
//  NSTimer+EOCBlockSupport.m
//  NSTimerRetainCycle
//
//  Created by 周泽文 on 2017/7/22.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "NSTimer+EOCBlockSupport.h"

@implementation NSTimer (EOCBlockSupport)
+(NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(eoc_blockInvoke:) userInfo:[block copy] repeats:repeats];
}
+(void)eoc_blockInvoke:(NSTimer *)timer{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}
@end
