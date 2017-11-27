//
//  ViewController.m
//  Dispatch_apply
//
//  Created by 周泽文 on 2017/6/20.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testDispatchApply] ;
    
//    [self DispatchApplySize_t] ;
    
    [self DispatchApplyAsync] ;
}

-(void)testDispatchApply{
    /**
     dispatch_apply(<#size_t iterations#>, <#dispatch_queue_t  _Nonnull queue#>, <#^(size_t)block#>)
     function 提交一个重复执行的 block 给 dispatch queue 直到执行完毕才返回
     第一个参数  size_t (unsinged long) iterations  重复的次数
     第二个参数  指定的dispatch queue 
     第三个参数 没有返回值有一个参数的block  参数标识的是 第几次执行 
     
     dispatch_apply 是将 dispatch_sync 和 dispatch_group 关联的API
     按照指定的次数将指定的block 追加到指定的 dispatch queue 中
     并等待全部处理完成,既然是等待，那么就会阻塞当前的线程
     */
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    dispatch_apply(10, concurrentQueue, ^(size_t index) {
        NSLog(@"%lu",index) ;
    }) ;
    
    
    // block中的任务 在 10次全部执行完毕之前 一直会阻塞主线程
    NSLog(@"the end of the function") ; // 最后才会打印
}

-(void)DispatchApplySize_t{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //不用使用for循环就可以对 数组的所有元素执行block操作
    // size_t 可以对每个block来做区分
    //因为是 并行队列 global queue 所以不一定按照 顺序来对所有的元素作操作
    NSArray * array = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    dispatch_apply(array.count, concurrentQueue, ^(size_t index) {
        NSLog(@"%lu%@ %@",index,[array objectAtIndex:index],[NSThread currentThread]);
    });
    
}


-(void)DispatchApplyAsync{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%@",[NSThread currentThread]);
        dispatch_apply(10, concurrentQueue, ^(size_t index) {
            NSLog(@"%lu %@",index,[NSThread currentThread]);
        });
        
        // 等待上面的 dispatch_apply 全部执行完毕
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程作操作");
        });
    });
    NSLog(@"the end of the function");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
