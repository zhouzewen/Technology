//
//  ViewController.m
//  触摸事件的传递
//
//  Created by fox/周泽文 on 16/7/18.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  hitTest
/*********************************************
使用视图，而不是单独创建图层的原因之一，图层不能直接处理触摸事件或手势
 但CALayer 有两个方法来处理事件
 
-containsPoint: 
 接受一个 CGPoint类型参数，返回BOOL值
 -hitTest:
 接受一个 CGPoint类型参数，返回图层本身或包含这个点的子图层
 *********************************************/

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (nonatomic,weak) CALayer *blueLayer ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;
}

-(void)initializeData
{
    self.title = @"CALayer触摸事件传递" ;
    self.blueLayer = [CALayer layer] ;
    self.blueLayer.frame = CGRectMake(0, 0, 150, 150) ;
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor ;
    [self.whiteView.layer addSublayer:self.blueLayer] ;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view] ;
    point = [self.whiteView.layer convertPoint:point fromLayer:self.view.layer] ;
    if ([self.whiteView.layer containsPoint:point])
    {
        point = [self.blueLayer convertPoint:point fromLayer:self.whiteView.layer] ;
        if ([self.blueLayer containsPoint:point])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"inside blueLayer" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
            
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil] ;
            [alert addAction:cancel] ;
            
            UIAlertAction * ensureButton = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"触点在蓝色的layer") ;
            }] ;
            [alert addAction:ensureButton] ;
            
            [self presentViewController:alert animated:YES completion:nil] ;
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"inside whiteLayer" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
            
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil] ;
            [alert addAction:cancel] ;
            
            UIAlertAction * ensureButton = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"触点在白色的layer") ;
            }] ;
            [alert addAction:ensureButton] ;
            
            [self presentViewController:alert animated:YES completion:nil] ;
        }
    }
}

@end
