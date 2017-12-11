//
//  ViewController.m
//  改变zPosition
//
//  Created by fox/周泽文 on 16/7/18.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;

@property (nonatomic,weak) UIButton * button1 ;

@property (nonatomic,weak) UIButton * button2 ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;
}

-(void)initializeData
{

//    self.redView.layer.zPosition = 1.0f ; // 将红色视图 提高到蓝色视图之上
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeSystem] ;
    button1.frame = CGRectMake(20, 300, 200, 50) ;
    button1.backgroundColor = [UIColor redColor] ;
    [button1 addTarget:self action:@selector(log1:) forControlEvents:UIControlEventTouchUpInside] ;
    self.button1 = button1 ;
    [self.view addSubview:self.button1] ;
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem] ;
    button2.frame = CGRectMake(20 + 50, 300, 200, 50) ;
    button2.backgroundColor = [UIColor cyanColor] ;
    [button2 addTarget:self action:@selector(log2:) forControlEvents:UIControlEventTouchUpInside] ;
    self.button2 = button2 ;
    [self.view addSubview:self.button2] ;
    
    /*********************************************
     1.按照两个button 添加的顺序，button2是覆盖在button1之上的
     2.所以点击buttn1,button2重叠的部分，相应的方法应该是button2的点击事件
     *********************************************/
    self.button1.layer.zPosition = 1.0f ; // 将button1 在视觉效果上提高到button2之上。
}

-(void)log1:(UIButton *)button
{
    NSLog(@"点击了button1" ) ;
}

-(void)log2:(UIButton *)button
{
    NSLog(@"点击了button2" ) ;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view] ;
    
    CALayer * layer = [self.redView.layer hitTest:point] ;
    
    if (layer == self.redView.layer)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Inside redView" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil] ;
        [alert addAction:cancel] ;
        
        UIAlertAction * ensureButton = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"触点在redView中") ;
        }] ;
        [alert addAction:ensureButton] ;
        
        [self presentViewController:alert animated:YES completion:nil] ;
    }
    
    CALayer * layer2 = [self.blueView.layer hitTest:point] ;
    if (layer2 == self.blueView.layer)
    {
        UIAlertController * alert2 = [UIAlertController alertControllerWithTitle:@"Inside blueView" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil] ;
        [alert2 addAction:cancel] ;
        
        UIAlertAction * ensureButton = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"触点在blueView中") ;
        }] ;
        [alert2 addAction:ensureButton] ;
        
        [self presentViewController:alert2 animated:YES completion:nil] ;
    }
}


@end
