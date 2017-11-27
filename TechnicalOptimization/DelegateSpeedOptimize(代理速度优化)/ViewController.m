//
//  ViewController.m
//  DelegateSpeedOptimize
//
//  Created by 周泽文 on 2017/7/20.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "EOCNetworkFetcher.h"
@interface ViewController ()<EOCNetworkFetcherDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EOCNetworkFetcher * fetcher = [[EOCNetworkFetcher alloc] init];
    fetcher.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
