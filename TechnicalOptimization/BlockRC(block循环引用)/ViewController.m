//
//  ViewController.m
//  BlockTest
//
//  Created by 周泽文 on 2017/8/17.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "BlockTestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem] ;
    button.frame = CGRectMake(100, 100, 100, 50) ;
    [button setTitle:@"button" forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:button] ;
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)pushView:(UIButton *)button
{
    [[UIApplication sharedApplication] statusBarFrame];
    BlockTestViewController * ctr = [[BlockTestViewController alloc]init];
    [self.navigationController pushViewController:ctr animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
