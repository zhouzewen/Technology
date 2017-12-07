//
//  ViewController.m
//  ScalingAnimation(缩放动画)
//
//  Created by 周泽文 on 2017/11/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIView *view1;
@property(nonatomic,assign)BOOL isZoom;
@property(nonatomic,strong)UIWindow *window;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    _window.windowLevel = UIWindowLevelAlert;
//    _window.backgroundColor = [UIColor grayColor];
    
    
    _isZoom = YES;
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 150, 150)];
    _view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:_view1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scalingView:)];
    [_view1 addGestureRecognizer:tap];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10 + 150 + 10, 100, 150, 150)];
    view2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view2];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scalingView2:)];
    [view2 addGestureRecognizer:tap2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 100 + 10 + 150, 150, 150)];
    view3.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(10 + 10 + 150, 100 + 10 + 150, 150, 150)];
    view4.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view4];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)scalingView:(UITapGestureRecognizer *)tap{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    CGRect frame ;
    if (_isZoom == YES) {
        frame = CGRectMake(10, 100, 300, 300);
    }else{
        frame = CGRectMake(10, 100, 150, 150);
    }
    [self transformView:tap.view duration:0.75 targetFrame:frame];
    _isZoom = !_isZoom;
}
-(void)scalingView2:(UITapGestureRecognizer *)tap{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    CGRect frame ;
    if (_isZoom == YES) {
        frame = CGRectMake(10, 100, 300, 300);
    }else{
        frame = CGRectMake(10 + 150 + 10, 100, 150, 150);
    }
    [self transformView:tap.view duration:0.75 targetFrame:frame];
    _isZoom = !_isZoom;
}
// 做一个view的放大或者缩小的动画
-(void)transformView:(UIView *)view duration:(CGFloat)duration targetFrame:(CGRect)frame{
    [view.superview bringSubviewToFront:view];
    [UIView animateWithDuration:duration animations:^{
        view.frame = frame;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
