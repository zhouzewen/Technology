//
//  ViewController.m
//  Dispatch_barrier_async
//
//  Created by 周泽文 on 2017/6/18.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testDispatchBarrier] ;
}

void (^block)() = ^{
    static int count = 1 ;
    NSLog(@"第%i 读取操作 %@",count++,[NSThread currentThread]) ;
} ;
-(void)test
{
    /**
     访问数据库或文件时，serial dispatch queue可以避免数据竞争
     写入的处理确实不可与其他的写入处理 或包含读取处理的操作并行执行
     但是如果是读取处理之间 是可以并行的
     为了提高读取效率，可以将读取操作添加到 concurrent dispatch queue中
     而写入处理只需要在读取处理没有执行的状态下，添加到 serial dispatch queue中（写入处理执行完毕之前，读取处理是不能操作的）
     */
    
    dispatch_queue_t queue = dispatch_queue_create("com.zhouzewen.concurrentQueue", DISPATCH_QUEUE_CONCURRENT) ;
    
    // 因为block中有自增的操作，按照顺序的情况下 应该是 123~10 执行
    // 但是因为是 并行执行的 所以先后顺序就无法保证了
    for (int i = 1 ; i < 10; i++) {
        dispatch_async(queue, ^{
            block() ;
        }) ;
    }
    
}

-(void)testDispatchBarrier{
    /**
     dispatch_barrier_sync(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
     该函数 提交一个 barrier block 给 dispatch queue 并立刻返回void 不阻塞当前线程
     第一个参数必须是通过dispatch_queue_create方式创建的concurrentQueue，不能获取global queue
     第二个参数是一个无参数无返回值的block
     
     dispatch_barrie_async 函数会等待追加到 concurrent dispatch queue上，并等待queue上之前的所有block全部执行结束之后
     再执行 barrier block  在barrier block 之后 submit的block 都会等待 barrierblock 执行完毕才会执行
     直到 指定的处理执行完毕， concurrent dispatch queue才恢复正常的 并行执行
     也就是说，在barrier block 执行的那个时间点，queue 中只会执行一个barrier block 这一个任务
     */
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.zhouzewen.concurrentQueue", DISPATCH_QUEUE_CONCURRENT) ;
    
    for (int i = 1; i < 5; i++)
    {
        dispatch_async(concurrentQueue, block) ;
    }
    //前面四个block 全部执行完毕之后才会执行 barrier block
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"barrier") ;
        block() ;
    }) ;
    
    // 这四个block 会等到 barrier block 执行完毕才会 并行执行
    for (int i = 6; i < 10; i++)
    {
        dispatch_async(concurrentQueue, block) ;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
