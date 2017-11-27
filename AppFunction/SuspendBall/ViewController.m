//
//  ViewController.m
//  SuspendBall
//
//  Created by 周泽文 on 2017/7/24.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "Zzw_SuspendBallButton.h"
@interface ViewController ()<Zzw_SuspendBallButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Zzw_SuspendBallButton *suspendBall = [Zzw_SuspendBallButton suspendBallWithFrame:CGRectMake(0, 64, 50, 50) delegate:self subBallImagePath:@"circle"];
    Zzw_SuspendBallButton * suspendBall = [[Zzw_SuspendBallButton sharedInstance] suspendBallWithFrame:CGRectMake(0, 64, 50, 50) delegate:self subBallImagePath:@"circle"];
    [self.view addSubview:suspendBall];
    
    Zzw_SuspendBallButton * suspendBall2 = [[Zzw_SuspendBallButton sharedInstance] suspendBallWithFrame:CGRectMake(0, 64, 50, 50) delegate:self subBallImagePath:@"circle"];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)clickButton:(Zzw_SuspendBallButton *)button{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
