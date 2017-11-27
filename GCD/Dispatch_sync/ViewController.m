//
//  ViewController.m
//  Dispatch_sync
//
//  Created by 周泽文 on 2017/6/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     async  非同步  asynchronous 的缩写
     sync   同步    synchronous 的缩写
     
     dispatch_sync 函数 意味着同步，将指定的block 同步追加到 dispatch queue 中
     在block 处理结束之前 函数dispatch_sync 会一直等待 阻塞当前线程
     直到 dispatch queue 将block执行完成 dispatch_sync才会返回 void
     */
    
    [self testDispatchSync];
    
//    [self testDeadLockByDispatchSyncWithMainQueueInMainThread];
}

-(void)testDispatchSync{
    // 让系统生成一个默认优先级的 并行队列
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //同步让并行队列执行一个block
    dispatch_sync(concurrentQueue, ^{
        for (int i = 0; i < 10; i++) {
            sleep(1) ;
            NSLog(@"同步%i",i);
        }
    }) ;
    NSLog(@"the end of the function") ;
}

// 主线程 dispatch_sync
-(void)testDeadLockByDispatchSyncWithMainQueueInMainThread{
    /**
     死锁 是使用多线程的时候特别需要注意的点
     */
    dispatch_queue_t queue = dispatch_get_main_queue() ;// 拿到主线程队列
    
    // block执行完毕之前 dispatch_sync 阻塞 主线程
    dispatch_sync(queue, ^{ // 主线程队列 去执行 block
        NSLog(@"主线程中 同步 执行的任务") ;
    }) ;
    // 主线程 一直等待 dispatch_sync返回  但是 dispatch_sync 又需要主线程去执行block
    // 所以 main queue会一直阻塞
    
}

-(void)testDeadLockByDispatchAsyncWithSerialQueueInMainThread{
    
    // 生成一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.zhouzewen.serialQueue", NULL) ;
    
    // 异步 让串行队列执 queue 行一个block
    dispatch_async(queue, ^{
        
        // 同步 让串行队列 queue 执行block
        dispatch_sync(queue, ^{
            NSLog(@"串行队列异步执行 又同步执行") ;
        }) ;
    }) ;
    
    /**
     异步让 queue执行 一个block ，假设是线程a在执行 这个block
     但是block的内容是 queue 异步去执行另外一个block 并等待返回结果
     问题是当前线程a正在等待 串行队列queue 又让线程a去执行另外一个block 所以死锁
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
