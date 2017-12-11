//
//  ViewController.m
//  边框
//
//  Created by fox/周泽文 on 16/7/19.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  设置图层的边框
/*********************************************
 1.CALayer的属性 borderWidth borderColor 
 borderWidth 点为单位定义边框粗细的浮点数，默认为0
 borderColor  边框的颜色 默认为黑色
 
 2.boderColor 是 CGColorRef 类型，不是UIColor即不是Cocoa内置对象
 CGColorRef在 引用/释放的时候 表现的和NSObject类似，但Objective-C不支持
 所以 CGColorRef 即使是强引用也只能通过assign声明
 
 3.边框的绘制是在图层边界里，是在所有子图层之前。
 
 4. 边框不会把图层寄宿图或 子图层的形状包括，当子图层超过边界，或寄宿图在透明区域
 有一个透明蒙版，边框只会沿着图层的边界绘制。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;
}

-(void)initializeData
{
    self.layerView1.layer.cornerRadius = 20.0f ;
    self.layerView1.layer.borderWidth = 5.0f ;
    
    self.layerView2.layer.cornerRadius = 20.0f ;
    self.layerView2.layer.borderWidth = 5.0f ;
    self.layerView2.layer.masksToBounds = YES ;
}



@end
