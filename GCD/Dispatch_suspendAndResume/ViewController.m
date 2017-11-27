//
//  ViewController.m
//  resume
//
//  Created by 周泽文 on 2017/6/21.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    [self test];
    
    [self testDispatchSuspendAndResume];
}

-(void)test{
    /**
     追加大量任务到 dispatch queue 中，若不希望立刻执行 这些追加的任务
     (运算结果被block捕获 追加的任务可能对结果造成影响)
     dispatch_suspend  挂起
     dispatch_resume   恢复
     
     特别注意的是，挂起 dispatch queue时，已经执行 正在执行的任务是不会受到影响的
     只有 还没有执行的任务 才会被挂起 停止执行
     */
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"suspend queue");
    dispatch_suspend(queue) ;
    NSLog(@"do something in main thread");
    sleep(1) ;
    dispatch_resume(queue);
    dispatch_async(queue, ^{
        NSLog(@"do something");
    });
    
    NSLog(@"%s",__func__);
}

-(void)testDispatchSuspendAndResume{
    dispatch_queue_t queue = dispatch_queue_create("com.zhouzewen.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 1; i < 10; i++) {
            NSLog(@"%i %@",i,[NSThread currentThread]);
            if (i == 5) {
                dispatch_suspend(queue);
                sleep(2);
                dispatch_resume(queue);
            }
        }
    });
    NSLog(@"the end of the function");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

