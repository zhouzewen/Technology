//
//  ViewController.m
//  MessageForwarding
//
//  Created by 周泽文 on 2017/7/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "EOCAutoDictionary.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EOCAutoDictionary *dic = [EOCAutoDictionary new];
    dic.date = [NSDate dateWithTimeIntervalSince1970:475372800];
    NSLog(@"dic.date = %@",dic.date);
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
