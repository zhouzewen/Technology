//
//  ViewController.m
//  Dispatch_after
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
    
    
    /**
     1 如果 dispatch_time_t 单独创建，创建的时候立刻开始计时
     2 主线程如果执行了耗时的操作，那么 dispatch_after block 执行的时间可能会比 time确定的时间 更晚
     3 主线程中 dispatch_after之后的内容 也可能会在 dispatch_after之前执行
     */
//    [self testDispatchAfter] ;
    
    [self testWallTime] ;
    
}
-(void)testDispatchAfter{
    NSLog(@"%@",[NSThread currentThread]) ;
    // 分配一个dispatch time  dispathc_time_now 从现在开始  延迟 3*NSEC_PER_SEC 3秒
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC) ; // 从此行开始立刻计时
    NSLog(@"%@",[NSThread currentThread]) ;
    
    /**
     dispatch_time(<#dispatch_time_t when#>, <#int64_t delta#>)
     
     */
    /**
     dispatch after  不是在time之后就立刻在 queue中 执行block的内容
     而是把block的内容追加到queue中
     下面是把block追加到 main queue 中执行，而主队列的runloop是 1/60s执行一次
     所以这个block最快在 time后执行，最慢是 time+1/60s 执行
     如果主线程中有大量的任务需要处理，那么这个block可能需要更长的时间。
     如下面的例子中，主线程休眠5秒的时候，虽然上面的time在3秒的时候就已经计时完成了
     但是主线程 还在 sleep 所以会在sleep end 之后再执行
     
     */
    
    sleep(5) ;
    NSLog(@"sleep end") ;
    
    // 虽然 这一行 写在 for的前面，但是实际的执行结果是 for 会先执行
    dispatch_after(time, dispatch_get_main_queue(), ^{NSLog(@"%@",[NSThread currentThread]) ;}) ;
    
    for (int i = 0; i < 3; i++) {
        sleep(1) ;
        NSLog(@"%@ %i",[NSThread currentThread],i) ;
    }
    NSLog(@"4the end of the function") ;
    
}

-(void)testDispatchAfter1
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC) ; // 从此行开始立刻计时
    
    /**
     上面的计时是从那一行开始 time就开始计时了，两秒之后计时完成
     for循环 需要执行3秒 
     在for循环执行到第二秒的时候，上面的time已经计时完成了
     for执行完之后 dispatch after已经过了3秒了 超过了计时的两秒，所以会立刻执行
     
     所以虽然是2秒后把 block添加到主线程，但是由于主线程执行了耗时的操作，导致实际的执行block的时间是3秒之后
     */
    for (int i = 0; i < 3; i++) {
        sleep(1) ;
        NSLog(@"5%i",i) ;
    }
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"22%@",[NSThread currentThread]) ;
    }) ;
    
}
-(void)testDispatchAfter2
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC) ; // 从此行开始立刻计时
    
    /**
     上面的计时是从那一行开始 time就开始计时了，五秒之后计时完成
     for循环 需要执行3秒
     for执行完之后 dispatch after已经过了3秒了但是还剩下两秒
     所以for循环执行完之后，再过两秒 会把block添加到main_queue中执行
     
     所以定时是5秒把 block 添加到 main thread 因为主线程是闲置的，所以会立刻执行block
     */
    for (int i = 0; i < 3; i++) {
        sleep(1) ;
        NSLog(@"5%i",i) ;
    }
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"22%@",[NSThread currentThread]) ;
    }) ;
    
}

-(void)testDispatchAfter3
{
    for (int i = 0; i < 3; i++) {
        sleep(1) ;
        NSLog(@"5%i",i) ;
    }
    /**
     time的生成 被写到 dispatch_after中了，没有单独写出来
     所以 执行的顺序是  先执行上面的for循环
     然后 dispatch after ，当执行到下面这一行的时候 ，time才开始计时，5秒之后把block中的内容添加到main queue中
     
     和testDispatchAfter2 是不同的
     上面的 block会在 for循环结束之后 2s 执行
     但是testDispatchAfter3 会在for循环结束之后 5s 执行
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"22%@",[NSThread currentThread]) ;
    }) ;
    
}


-(void)testWallTime{
    dispatch_time_t time = dispatch_walltime(NULL, 2*NSEC_PER_SEC) ;
    NSLog(@"%@",[NSThread currentThread]) ;
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"22%@",[NSThread currentThread]) ;
    }) ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
