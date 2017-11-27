//
//  ViewController.m
//  TestViewRotation
//
//  Created by 周泽文 on 2017/11/6.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "TestClass.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view, typically from a nib.
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    view2.backgroundColor = [UIColor redColor];
    label2.text = @"222";
    [view2 addSubview:label2];
    [self.view addSubview:view2];
    
    
    TestClass *class = [[TestClass alloc] initWithFrame:[UIScreen mainScreen].bounds];
    class.backgroundColor = [UIColor cyanColor];
    [class testMethod];
    [[UIApplication sharedApplication].keyWindow addSubview:class];
    
    
//    NSArray *arr = [UIApplication sharedApplication].windows;
//    UIWindow *mmwindow = [[UIApplication sharedApplication].windows firstObject];
//    [mmwindow addSubview:class];
    //    [self.view.window addSubview:class];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
