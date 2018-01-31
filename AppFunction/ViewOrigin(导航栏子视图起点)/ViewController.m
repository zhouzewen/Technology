//
//  ViewController.m
//  ViewFrameOrigin
//
//  Created by 周泽文 on 2017/8/5.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "AddNaviViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 100, 20)];
    label.text = @"222";
    label.textColor = [UIColor cyanColor];
    [self.view addSubview:label];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Zzw_pushNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)dealloc{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)Zzw_pushNextView{
    /**
     如果不用storybard 要写导航栏就要这样
     如果想要自定义导航栏，可以自己创建导航栏控制器
     */
    AddNaviViewController * ctr = [[AddNaviViewController alloc] init];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:ctr];
    [self presentViewController:navi animated:YES completion:nil];
    
}

@end
