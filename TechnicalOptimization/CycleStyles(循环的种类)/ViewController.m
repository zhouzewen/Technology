//
//  ViewController.m
//  CycleStyles(循环的种类)
//
//  Created by 周泽文 on 2017/12/8.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *array = @[@"1",@"2",@"3"];
    // 使用for循环
//    [self cycleByForWithArray:array];
    
    // 使用NSEnumerator
    // 代码量大，但对不同的集合遍历的语法相似，内部可以简单通过reverseObjectEnumerator进行反向遍历
    
    // 使用for in
//    [self cycleByForInWithArray:array];
    
    // 使用block
//    [self cycleByBlockWithArray:array];
    
    // 使用GCD
    [self cycleByGCDWithArray:array];
}
-(void)cycleByForWithArray:(NSArray *)array{
    /**
     字典和集合的内部是无序的，在遍历时需要借助一个新的数组来处理
     */
    for (int i = 0; i < array.count; i++) {
        NSLog(@"%@",array[i]);
    }
}
-(void)cycleByForInWithArray:(NSArray *)array{
    //无法获得当前遍历操作的下标
    for (NSString *str in array) {
        NSLog(@"%@",str);
    }
}

-(void)cycleByBlockWithArray:(NSArray *)array{
    
    
    [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
    }];
}
-(void)cycleByGCDWithArray:(NSArray *)array{
    /**
     优点
     能实现字典、数组的遍历，适合处理耗时较长、迭代次数较多的情况；会开启多条线程处理遍历的任务，执行的效率高
     缺点
     对于字典和集合的处理需要借助数组，无法实现反向遍历
     */
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_apply(array.count, queue, ^(size_t index) {
        NSLog(@"%@--%@",array[index],[NSThread currentThread]);
    });
}


@end
