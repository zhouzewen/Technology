//
//  NSTimer+EOCBlockSupport.h
//  NSTimerRetainCycle
//
//  Created by 周泽文 on 2017/7/22.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (EOCBlockSupport)
+(NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
