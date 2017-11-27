//
//  ViewController.m
//  Dispatch_once
//
//  Created by 周泽文 on 2017/6/21.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test] ;
}

-(void)test{
    /**
     dispatch_once 函数 是保证应用程序生命周期里只执行一次的API
     在多线程环境下，也会保证只执行一次  一般这个函数用来生成单例
     
     */
    static int initialized = NO ;
    if (initialized == NO) {
        // 初始化
        initialized = YES ;
    }
    
    // 上面的初始化代码可以用 dispatch_once来写
    static dispatch_once_t pred ;
    dispatch_once(&pred, ^{
        //初始化
    });
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(concurrentQueue, ^{
            Person * person = [Person shareInstance];
            NSLog(@"%@",person);
        });
    }
    sleep(2);
    for (int i = 0; i < 10; i++) {
        dispatch_async(concurrentQueue, ^{
            Person * person = [[Person alloc] init];
            NSLog(@"%@",person);
        });
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
