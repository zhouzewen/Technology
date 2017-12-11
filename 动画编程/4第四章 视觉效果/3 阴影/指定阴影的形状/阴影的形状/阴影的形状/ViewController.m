//
//  ViewController.m
//  阴影的形状
//
//  Created by fox/周泽文 on 16/7/19.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


//  shadowPath
/*********************************************
 1.图层阴影并不总是放的，而是从图层内容的形状继承而来。但计算阴影是非常耗资源的，尤其是图层有
 多个子图层，每个图层有透明效果的寄宿图时。
 2.若事先知道 阴影是上面形状，可以指定shadowPath来提高性能。
 shadowPath 类型CGPahtRef(指向CGPath的指针) CGPath是一个CoreGraphics对象
 指定 矢量图形，可以通过这个属性单独与图层形状之外设定阴影的形状。
 *********************************************/


/*********************************************
 1.矩形 或 圆  CGPath简单明了
 2.复杂的图形 UIBezierPath 更加合适
 *********************************************/
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * layerView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 140, 200)] ;
    [self.view addSubview:layerView1] ;
    
    UIView * layerView2 = [[UIView alloc]initWithFrame:CGRectMake(160, 100, 140, 200)] ;
    [self.view addSubview:layerView2] ;
    
    // enable layer shadows
    layerView1.layer.shadowOpacity = 0.5f ;
    layerView2.layer.shadowOpacity = 0.5f ;
    
    // create a square shadow
    CGMutablePathRef squarePath = CGPathCreateMutable() ;
    CGPathAddRect(squarePath, NULL, layerView1.bounds) ;
    layerView1.layer.shadowPath = squarePath ;
    CGPathRelease(squarePath) ;
    
    // create a circular shadow
    CGMutablePathRef circlePath = CGPathCreateMutable() ;
    CGPathAddEllipseInRect(circlePath, NULL, layerView2.bounds) ;
    layerView2.layer.shadowPath = circlePath ;
    CGPathRelease(circlePath) ;
    
}



@end
