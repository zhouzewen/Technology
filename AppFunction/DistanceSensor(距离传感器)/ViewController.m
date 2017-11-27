//
//  ViewController.m
//  DistanceSensor
//
//  Created by 周泽文 on 2017/9/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(100, 200, 100, 50)];
    [button2 setTitle:@"关闭" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(closeDistanceSensor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    // proximity monitoring 接近监测 默认是关闭的，先打开
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
}
-(void)proximityStateDidChange{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"靠近");
    }else{
        NSLog(@"远离");
    }
}

-(void)backUp{
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)closeDistanceSensor{
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
