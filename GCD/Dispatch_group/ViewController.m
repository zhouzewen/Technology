//
//  ViewController.m
//  Dispatch_group
//
//  Created by 周泽文 on 2017/6/17.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testDispatchGroupByNotify] ;
    
    [self testDispatchGroupByWait2] ;
}

-(void)testDispatchGroupByNotify{
    
    /**
      想要在执行多个任务 之后 处理这些任务的执行结果
      对串行队列而言，非常的简单，只需要将多个任务添加到串行队列中，然后把处理的操作追加到最后
     但是对于 并行队列而言处理起来就非常的麻烦了
     而 dispatch group 函数可以很简单方便的实现
     */
    //创建一个 并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    dispatch_group_t group = dispatch_group_create() ;// 创建一个group
    
    // 分别添加三个任务到 并行队列中  用group管理
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        NSLog(@"block1") ;
    }) ;
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        NSLog(@"block2") ;
    }) ;
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        NSLog(@"block3") ;
    }) ;
    
    /**
     group 监视 并行队列 全部执行完之后
     notify  main_queue 执行 block
     */
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{NSLog(@"done") ;});
    
    
}


-(void)testDispatchGroupByWait{
    dispatch_group_t group = dispatch_group_create() ;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@ block1",[NSThread currentThread]) ;
    }) ;
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@ block2",[NSThread currentThread]) ;
    }) ;
    
    dispatch_group_async(group, queue, ^{
        sleep(3) ;
        NSLog(@"%@ block3",[NSThread currentThread]) ;
    }) ;
    
    // 永久等待 group执行完毕，wait会阻塞当前线程，当前thread会停止，不执行
    // 因为 wait是在主线程中执行的，所以会一直主线程
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER) ;
    NSLog(@"the end of function") ;
    
    
}

-(void)testDispatchGroupByWait2{
    /**
     dispatch_group_wait 是有返回值的
     如果在指定的时间内，group中包含的任务都执行完毕，那么返回值为0
     如果没有执行完毕，group的返回值不会为0
     当设置wait的时间为forever的时候，dispatch_group_wait函数返回的时候一定是0
     */
    dispatch_group_t group = dispatch_group_create() ;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@ block1",[NSThread currentThread]) ;
    }) ;
    
    dispatch_group_async(group, queue, ^{
        sleep(5) ;
        NSLog(@"%@ block2",[NSThread currentThread]) ;
    }) ;
    
    dispatch_group_async(group, queue, ^{
        sleep(3) ;
        NSLog(@"%@ block3",[NSThread currentThread]) ;
    }) ;
    
    /**
     这倒是一个可以测试 执行时间的方式，前提是当前thread没有执行耗时的操作，否则dispatch_time会延迟
     
     long result = dispatch_group_wait(group,DISPATCH_TIME_NOW),不用任何等待，可以判断group执行是否完毕
     在main thread 的runloop每次循环中，可以检查执行是否借宿，从而不耗费多余的等待时间
     
     */
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC) ; //从这行开始就计时两秒
    long result = dispatch_group_wait(group, time) ;
    
    if (result == 0) {
        NSLog(@"group中的任务在两秒的时间内全部执行完毕") ;
    }else{
        // 三次 测试的结果 result都为49 不管是一个任务没有执行完毕，还是两个任务没有执行完毕
        NSLog(@"resulet = %ld group中的任务在两秒的时间内没有执行完毕",result) ;
    }
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
