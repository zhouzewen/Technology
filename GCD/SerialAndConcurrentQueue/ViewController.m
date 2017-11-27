//
//  ViewController.m
//  SerialAndConcurrentQueue
//
//  Created by CivetDev on 2017/6/15.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     dispatch queue == thread ？
     不对 dispatch queue 是若干任务的组合
     若干任务 由block语法来定义 
     这些任务 类似排队的队列 (queue的本意) 串行（纵队） 并行（横队）
     thread 是用来执行这些任务的
     */
//    [self testSerialQueue];
    
    [self testConcurrenQueueByAsync];
   
//    [self testConcurrentQueueBySync];
    
//    [self testGlobalQueue];
    
}

-(void)testGlobalQueue
{
    
    // 系统分配一个 优先级为 default的 dispatch queue 这个 queue是并行的
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    
    NSLog(@"%@",[NSThread currentThread]) ;
    
    // 异步 给这个 dispatch queue分配一个任务
    dispatch_async(globalQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async1 === %i",i) ;
        }

    }) ;
    
    // 异步给这个dispatch queue 分配第二个任务
    dispatch_async(globalQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async2 === %i",i) ;
        }
    
    }) ;
    
    // 因为dispatch queue是并行的，所以这两个block包含的任务会并行执行，所以会开启两个子线程来完成。
    
}

-(void)testConcurrenQueueByAsync
{
    
    // 定义一个并行 dispatch queue
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.zhouzewen.TestConcurrentQueue", DISPATCH_QUEUE_CONCURRENT) ;

    NSLog(@"%@",[NSThread currentThread]) ;
    
    
    // 异步 给这个 dispatch queue 分派一个任务
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async1 === %i",i) ;
        }

    }) ;
    
    // 异步 给这个 dispatch queue 分配第二个任务
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async2 === %i",i) ;
        }
    }) ;
    
    // 因为这个 dispatch queue是 并行的，所以会同时这行这两个任务
    // 又因为是异步执行，系统会调用两个子线程来执行。
    NSLog(@"the end of function") ;
     
     
}

-(void)testConcurrentQueueBySync{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.zhouzewen.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    /**
     dispatch_sync(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
     该函数的作用是给一个 dispatch queue 指定一个block
     函数会阻塞当前线程 直到 dispatch queue 执行完 block 然后返回void
     第一个参数是指定 dispatch queue
     第二个参数是指定 一个没有参数和返回值的block
     */
     //同步 给这个 dispatch queue 分配一个任务
     dispatch_sync(concurrentQueue, ^{
     NSLog(@"%@",[NSThread currentThread]) ;
     for (int i = 0; i < 10; i++) {
     NSLog(@"sync1 === %i",i) ;
     }
     }) ;
     
     // 同步的方式 给这个 dispatch queue 分配第二个任务
     dispatch_sync(concurrentQueue, ^{
     NSLog(@"%@",[NSThread currentThread]) ;
     for (int i = 0; i < 10; i++) {
     NSLog(@"sync2 === %i",i) ;
     }
     }) ;
     
     // 因为是 同步的方式 所以是在主线程中执行，而主线程是串行队列
     // 所以虽然 dispatch queue是并行，但是仍然会按照FIFO的规则执行。
     NSLog(@"the end of function") ;
     

    
   
}

-(void)testSerialQueue
{
    /**
     定义一个串行的dispatch queue
     dispatch_queue_create(<#const char * _Nullable label#>, <#dispatch_queue_attr_t  _Nullable attr#>)
     第一个参数是队列的标识符 在调试的时候可以用来区分不同的队列
     第二个参数是 定义队列的性质 串行还是 并行
     DISPATCH_QUEUE_SERIAL == NULL 宏定义中 两者是相同的 都代表串行队列
     DISPATCH_QUEUE_CONCURRENT    代表并行队列
     
     */

    dispatch_queue_t serialQueue = dispatch_queue_create("com.zhouzewen.TestSerialQueue", NULL) ;
    

    NSLog(@"%@",[NSThread currentThread]) ;
    
    /**
     dispatch_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
     这个函数的作用是 提交一个异步执行的block 给一个queue 并且立即返回void
     第一个参数是 queue  第二个参数是一个没有返回值没有参数的block
     因为返回值为 void 所有不需要定义变量来接收这个函数的返回值
     因为是立即返回的，所以不会阻塞当前线程(调用这个函数的线程)
    
     */

    dispatch_async(serialQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0;  i < 10; i++) {
            NSLog(@"async1 ====%i",i) ;
        }
    }) ;
    
    
    // 异步给这个 dispatch queue 分配第二个任务
    dispatch_async(serialQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async2 ====%i",i) ;
        }
    }) ;
    
    
    // 异步给这个 dispatch queue 分配第三个任务
    dispatch_async(serialQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async3 ====%i",i) ;
        }
    }) ;
    
    // 因为这个dispatch queue 是串行的，所以block定义的三个任务会按照代码的先后顺序FIFO来执行
    // 又因为是异步执行，所以系统会分配一个闲置的子线程来执行。
    NSLog(@"the end of function") ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
