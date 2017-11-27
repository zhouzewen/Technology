//
//  ViewController.m
//  MethodRunTimeCaculate
//
//  Created by 周泽文 on 2017/7/21.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import <mach/mach_time.h>

#define LoopTimes 10000000//1千万次
@interface ViewController ()

@end

@implementation ViewController

CGFloat BNRTimeBlock(void(^block)(void)){
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        return  -1.0;
    }
    
    uint64_t start = mach_absolute_time();
    block();
    uint64_t end = mach_absolute_time();
    
    uint64_t elapsed = end - start;
    uint64_t nanos = elapsed * info.numer/info.denom;
    
    return (CGFloat)nanos/NSEC_PER_SEC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat time;
    NSString * ting1 = @"hi";
    NSString * ting2 = @"hello there";
    
    time = BNRTimeBlock(^{
        for (int i = 0; i < LoopTimes; i++) {
            [ting1 isEqual:ting2];
        }
    });
    NSLog(@"isEqual time %f",time);
    
    time = BNRTimeBlock(^{
        for (int i = 0; i < LoopTimes; i++) {
            [ting1 isEqualToString:ting2];
        }
    });
    NSLog(@"isEqual time %f",time);
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
