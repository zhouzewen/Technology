//
//  ViewController.m
//  TouchOnceButton(按钮防重复点击)
//
//  Created by 周泽文 on 2017/11/10.
//  Copyright © 2017年 zhouzewen. All rights reserved.
// 参考资料 http://www.cocoachina.com/ios/20171108/21086.html

#import "ViewController.h"
#import "UIButton+TouchOnce.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.timeInterval = 2.0;
//    button.isIgnoreEvent = YES;
    [button setTitle:@"222" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 100, 100, 50)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"333" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(100, 200, 100, 50)];
    [button2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)buttonAction:(UIButton *)button{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    //1
//    [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonAction:) object:button];
//    [self performSelector:@selector(buttonAction:) withObject:button afterDelay:0.2f];
    
    
}
-(void)buttonAction2:(UIButton *)button{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:1.0f];
}
-(void)changeButtonStatus:(UIButton *)button{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    button.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
