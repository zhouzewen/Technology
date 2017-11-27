//
//  TestViewController.m
//  NSTimerRetainCycle
//
//  Created by 周泽文 on 2017/7/22.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "TestViewController.h"
#import "EOCClass.h"
#import "HWWeakTimerTarget.h"
@interface TestViewController ()
@property(nonatomic,weak)NSTimer * timer;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    EOCClass * class = [[EOCClass alloc] init];
//    [class startPolling];
    
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(100, 100, 100, 50)];
//    [btn setTitle:@"停止" forState:UIControlStateNormal];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopTimer)];
//    [self.view addGestureRecognizer:tap];

   _timer = [HWWeakTimerTarget scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(log11) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self stopTimer];
}
-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
-(void)log11{
    NSLog(@"22");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
