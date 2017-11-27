//
//  ViewController.m
//  Dispatch_set_target_queue
//
//  Created by 周泽文 on 2017/6/16.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testSetDispatchQueue] ;
//    [self testTargetQueueBySerialQueue] ;
    [self testTargetQueueByConcurrentQueue] ;
}

-(void)testTargetQueueByConcurrentQueue
{
    dispatch_queue_t targetQueue = dispatch_queue_create("com.zhouzewen.targetQueue", DISPATCH_QUEUE_SERIAL) ;
    dispatch_queue_t concurrentQueue1 = dispatch_queue_create("com.zhouzewen.concurrentQueue1", DISPATCH_QUEUE_CONCURRENT) ;
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("com.zhouzheren.concurrentQueue2", DISPATCH_QUEUE_CONCURRENT) ;
    dispatch_queue_t concurrentQueue3 = dispatch_queue_create("com.zhouzheren.concurrentQueue3", DISPATCH_QUEUE_CONCURRENT) ;
    

    dispatch_async(concurrentQueue1, ^{
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            NSLog(@"async1 === %i",i);
        }
    });
    
    dispatch_async(concurrentQueue2, ^{
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            NSLog(@"async2 === %i",i);
        }
    });
    
    dispatch_async(concurrentQueue3, ^{
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            NSLog(@"async3 === %i",i);
        }
    });
}

-(void)testTargetQueueBySerialQueue
{
    dispatch_queue_t targetQueue = dispatch_queue_create("com.zhouzewen.targetQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.zhouzewen.queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("com.zhouzewen.queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("com.zhouzewen.queue3", DISPATCH_QUEUE_SERIAL);
    
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    /**
      如果把上面三行注释掉，那么就是异步执行三个串行队列，会用三个线程执行，这三个线程之间是并行的关系。
     但是当打开上面三行，也就是把这三个队列和 target队列都执行相同的优先级，那么这三个队列会依次执行，变成一个线程，串行执行三个block中的任务
     */
    dispatch_async(queue1, ^{
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            NSLog(@"async1 === %i",i);
        }
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            NSLog(@"async2 === %i",i);
        }
    });
    
    dispatch_async(queue3, ^{
        NSLog(@"%@",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            NSLog(@"async3 === %i",i);
        }
    });
    
}

-(void)testSetDispatchQueue
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.zhouzewen.serialQueue", NULL) ;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) ;
    
    // 将serialQueue的优先级 DISPATCH_QUEUE_PRIORITY_DEFAULT 改为和 globalQueue的优先级相同
    dispatch_set_target_queue(serialQueue, globalQueue) ;
    
    /**
     如果没有修改 serialQueue的优先级，会先打印 async1 10次  之后再打印 async2 10次
     修改serialQueue的优先级之后，由于两者的优先级相同所以会交替打印
     
     dispatch_set_target_queue的第一个参数不能是系统提供的queue（main dispatch Queue 和 global dispatch Queue）
     系统提供的queue优先级是由系统来设定，修改导致不确定的状况发送
     
     */

    NSLog(@"%@",[NSThread currentThread]) ;
    dispatch_async(serialQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async1 === %i",i) ;
        }
    }) ;
    
    dispatch_async(globalQueue, ^{
        NSLog(@"%@",[NSThread currentThread]) ;
        for (int i = 0; i < 10; i++) {
            NSLog(@"async2 === %i",i) ;
        }
        
    }) ;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
