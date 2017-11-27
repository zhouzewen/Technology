//
//  ViewController.m
//  OC语言的关键字
//
//  Created by 周泽文 on 2017/6/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "KeywordDefineClass.h"
#import "TestClass.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    globalString = @"222";
    NSLog(@"%p %@",globalString,globalString);
    
    TestClass * class = [[TestClass alloc] init];
    [class testMethod];
    [class testMethod2];
    
    KeywordDefineClass * kclass = [[KeywordDefineClass alloc]init];
    [kclass testConstKeyword];
    
    
    NSLog(@"%@",string);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
