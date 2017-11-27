//
//  ViewController.m
//  Dispatch_IO
//
//  Created by 周泽文 on 2017/6/21.
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
     不管是串行还是并行 读取文件 每次读取文件的长度是否有上限值？
     并行读取的时候，开几个线程来读取文件 速度最快 而且 效率最高
     */
    [self readFileAsyncBySerialQueue] ;
    
//    [self readFileAsyncByConcurrentQueue] ;
}
-(void)test{
    /**
     在读取较大文件是，如果将文件分成合适的大小 并使用global dispatch queue 并列读取
     应该会比一般的读取文件快不少
     实现这一功能需要用到 dispatch I/O  和 dispatch data
     dispatch_async(queue, ^{读取前一部分})
     dispatch_async(queue, ^{读取后一部分})
     
     类似的写法 可以将文件分成多块来读取，这些数据使用 dispatch data 来做简单的结合或分割
     */
    
}
-(void)readFileAsyncBySerialQueue{
    NSLog(@"start read file");
    NSString * path = @"/Users/civet/Downloads/Xcode_9_beta.xip";
    dispatch_queue_t serialQueue = dispatch_queue_create("com.zhouzewen.serialQueue", NULL);
    
    /**
     dispatch_fd_t 文件IO操作描述符
     #define    O_RDONLY     0x0000        open for reading only
     #define    O_WRONLY     0x0001        open for writing only
     #define    O_RDWR       0x0002        open for reading and writing
     #define    O_ACCMODE    0x0003        mask for above modes
     */
    dispatch_fd_t fd = open(path.UTF8String, O_RDONLY,0);
    
    /**
     dispatch_io_create(dispatch_io_type_t type, dispatch_fd_t fd, dispatch_queue_t queue, void (^cleanup_handler)(int error));
     dispatch_io_type_t  串行队列 DISPATCH_IO_STREAM
                         并行队列 DISPATCH_IO_RANDOM
     */
    dispatch_io_t io = dispatch_io_create(DISPATCH_IO_STREAM, fd, serialQueue, ^(int error) {
        close(fd);
    });
//    size_t water = 1024*1024;
    
    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    size_t water = fileSize;
    
    /**
     low 和 high 设置的一样的时候，每次读取的内容长度就是相同的
     因为测试的文件比较的小，所以每次读取的内容和文件的长度是一样的
     但是没有测试当文件以G为单位的时候，这样设置是否有问题
     还要考虑到效率的问题
     */
    dispatch_io_set_low_water(io, water);
    dispatch_io_set_high_water(io, water);
    NSMutableData * totalData = [[NSMutableData alloc] init];
    dispatch_io_read(io, 0, fileSize, serialQueue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
//        sleep(1);
        if (error == 0) {
            size_t len = dispatch_data_get_size(data);
            if (len > 0) {
                [totalData appendData:( NSData *)data];
            }
        }
        if (done) {
            NSLog(@"end read file");
            NSString * str = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
        }
    });
    
    
}

-(void)readFileAsyncByConcurrentQueue{
    NSLog(@"start read file");
    NSString * path = @"/Users/civet/Downloads/Additional_Tools_for_Xcode_9_beta.dmg";
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.zhouzewen.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_fd_t fd = open(path.UTF8String, O_RDONLY);
    dispatch_io_t io = dispatch_io_create(DISPATCH_IO_RANDOM, fd, concurrentQueue, ^(int error) {
        close(fd);
    });
    
    off_t currentSize = 0;
    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize ;
    size_t offset = fileSize/5 ;
    dispatch_group_t group = dispatch_group_create();
    NSMutableData * totalData = [[NSMutableData alloc] initWithLength:fileSize];
    for (; currentSize <= fileSize; currentSize+=offset) {
        dispatch_group_enter(group);
        dispatch_io_read(io, currentSize, offset, concurrentQueue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
            NSLog(@"%@",[NSThread currentThread]);
//            sleep(1);
            if (error == 0) {
                size_t len = dispatch_data_get_size(data);
                if (len > 0) {
                    const void *bytes = NULL;
                    (void)dispatch_data_create_map(data, &bytes, &len);
                    [totalData replaceBytesInRange:NSMakeRange(currentSize, len) withBytes:bytes length:len];
                }
            }
            
            if (done) {
                dispatch_group_leave(group);
            }
        });
    }
    dispatch_group_notify(group, concurrentQueue, ^{
        NSLog(@"end read file");
//        NSString * str = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
