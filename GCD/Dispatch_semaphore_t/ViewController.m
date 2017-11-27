//
//  ViewController.m
//  Dispatch_semaphore_t
//
//  Created by CivetDev on 2017/6/12.
//  Copyright © 2017年 zhouzewen. All rights reserved.
/**
 
 dispatch_queue_t dispatch_get_global_queue(long identifier, unsigned long flags);
 派发 队列    派发全局队列
 Description
 Returns a system-defined global concurrent queue with the specified quality of service class.
 返回一个系统定义的 全局同步队列 通过制定服务类特性
 This function returns a queue suitable for executing tasks with the specified quality-of-service level. Calls to the dispatch_suspend, dispatch_resume, and dispatch_set_context functions have no effect on the returned queues.
 这个 函数 通过指定合适执行任务服务等级特性的队列。调用 队列挂起  重启  和设置环境 这些方法 对返回这个队列没有影响
 Tasks submitted to the returned queue are scheduled concurrently with respect to one another.
 给这个返回的队列提交的任务 是 同步安排的考虑到另一个任务
 Parameters
 identifier
 The quality of service you want to give to tasks executed using this queue. 
 你想要用这个队列执行任务的服务特性
 Quality-of-service helps determine the priority given to tasks executed by the queue. 
 服务特性 帮助 决定 队列执行被添加任务的顺序
 You may specify the values QOS_CLASS_USER_INTERACTIVE, QOS_CLASS_USER_INITIATED, QOS_CLASS_UTILITY, or QOS_CLASS_BACKGROUND.
 你可以指定 这几种值
 Queues that handle user-interactive or user-initiated tasks have a higher priority than tasks meant to run in the background.
 处理用户响应 或者 用户初始化 任务的队列 有更高的优先级 比 在后台运行的任务
 In OS X 10.9 or earlier, you can specify one of the dispatch queue priority values, which are found in Dispatch Queue Priorities. 
 在OS X 10.9 或更早，你就能指定 一个 派发队列 优先级的值，这些值可以在 派发队列优先级中找到。
 These values map to an appropriate quality-of-service class.
 这些值 标识出 一个合适 服务特性 类
 flags
 Flags that are reserved for future use. Always specify 0 for this parameter.
 储备着为将来使用的标识旗，通常指定0 对这个参数
 Returns
 The requested global concurrent queue.
 请求的 全局同步队列
 Availability	iOS (4.0 and later), macOS (10.6 and later), tvOS (4.0 and later), watchOS (2.0 and later)
*/



#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testMethod3] ;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)testMethod
{
    // 一共会开启10个子线程异步来打印
    // 不一定始终是 固定的十个子线程
    // 但是子线程的总数目在执行 这个任务的时候是 保持10个的
    dispatch_group_t group = dispatch_group_create() ; // 创建一个dispatch group
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10) ; // 初始化一个信号量 总数为10
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ; // 并行队列，优先级默认
    
    for (int i = 0 ; i < 100; i++) {
        NSLog(@"%@",[NSThread currentThread]) ;
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ; // 信号量减一 永久等待
        dispatch_group_async(group, queue, ^{
            NSLog(@"%@ %i",[NSThread currentThread],i) ;
            sleep(10) ;
            dispatch_semaphore_signal(semaphore) ; // 信号量 加一
        }) ;
        
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER) ;
    
}

-(void)testMethod2
{
    dispatch_semaphore_t semephore = dispatch_semaphore_create(1) ;
    __block long x = 0 ;
    NSLog(@"0_x:%ld",x) ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(10) ;
        NSLog(@"waiting") ;
        x = dispatch_semaphore_signal(semephore) ;
        NSLog(@"1_x:%ld",x) ;
        
        sleep(10) ;
        NSLog(@"waking") ;
        x = dispatch_semaphore_signal(semephore) ;
        NSLog(@"2_x:%ld",x) ;
    }) ;
    
    x = dispatch_semaphore_wait(semephore, DISPATCH_TIME_FOREVER) ;
    NSLog(@"3_x:%ld",x) ;
    
    x = dispatch_semaphore_wait(semephore, DISPATCH_TIME_FOREVER) ;
    NSLog(@"wait 2 ") ;
    NSLog(@"4_x:%ld",x) ;
    

}

/*
 Dispatch_semaphore_t(5576,0x70000106a000) malloc: *** error for object 0x6000000fc380: pointer being freed was not allocated
 *** set a breakpoint in malloc_error_break to debug
 
 Dispatch_semaphore_t(14077,0x70000f8d3000) malloc: *** error for object 0x7fa5f003a000: double free
 *** set a breakpoint in malloc_error_break to debug
 
 当用dispatch_semaphore_create(N) (N>1的时候)
 在异步执行的时候是有一定的概率发生崩溃的 上面两种情况就是崩溃的时候控制台打印的信息
 
 */

-(void)testMethod3
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1) ;
    NSMutableArray * array = [[NSMutableArray alloc] init] ;
    NSLog(@"%p",array) ;
    NSLog(@"%p",semaphore) ;
    for (int i = 0;  i < 1000; ++i)
    {
        dispatch_async(queue, ^{// 分配一个子线程 异步来执行下面的内容
            // 如 number=5 的子线程来执行
            // 首先会log 一下当前的线程信息
            // 然后 会把 semaphore的值 减一 然后继续执行 休眠2秒的操作
            // 在休眠的过程中  number=5的线程不会再被分来 for循环中的操作
            // 一直到semaphore signal 调用之后  number=5的线程才会解放
            NSLog(@"%@ %i",[NSThread currentThread],i) ;

            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
            [array addObject:[NSNumber numberWithInt:i]] ;
            sleep(2) ;
            dispatch_semaphore_signal(semaphore) ;
        }) ;
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
