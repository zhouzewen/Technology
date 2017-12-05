//
//  ViewController.m
//  FPSCaculate(帧率计算)
//
//  Created by 周泽文 on 2017/12/5.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "ZZW_FPSLabel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    label1.text = @"123";
    [self.view addSubview:label1];
    
    
    ZZW_FPSLabel *label = [[ZZW_FPSLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:label];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
