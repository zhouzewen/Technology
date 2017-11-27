//
//  HWWeakTimerTarget.h
//  NSTimerRetainCycle
//
//  Created by 周泽文 on 2017/7/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWWeakTimerTarget : NSObject
@property(nonatomic,weak)id target;
@property(nonatomic,assign)SEL selector;
@property(nonatomic,weak)NSTimer *timer;

+(NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                    target:(id)aTarget
                                  selector:(SEL)aSelector
                                  userInfo:(id)userInfo
                                   repeats:(BOOL)repeats;
@end
