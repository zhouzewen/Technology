//
//  ViewController.m
//  阴影
//
//  Created by fox/周泽文 on 16/7/19.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  阴影
/*********************************************
 1.阴影有图层深度暗示的效果，强调正在显示的图层和优先级，也可以是装饰。
 2.shadowOpacity 默认值为0(不可见) 1.0(完全不透明)
 
 3.CALayer 三个属性 shadowColor  shadowOffset  shadowRadius 来控制阴影的表现。
 
 shadowColor 阴影的颜色，CGColorRef类型，默认是黑色
 
 shadowOffset 阴影的方向和距离 CGSize类型 宽度控制阴影横向的位移，高度控制纵向位移
 默认值 {0,-3} 阴影相对于Y轴向上位移3个点
 MacOS 中 左下是起点 所以阴影是向下的 ； iOS中 左上是起点，阴影是向上的。 
 
 shadowRadius 控制阴影的模糊度，0值 阴影和视图一样有非常明确的边界线。值越大，越模糊和自然
 *********************************************/

//  shadowPath
/*********************************************
 1.图层阴影并不总是放的，而是从图层内容的形状继承而来。但计算阴影是非常耗资源的，尤其是图层有
 多个子图层，每个图层有透明效果的寄宿图时。
 2.若事先知道 阴影是上面形状，可以指定shadowPath来提高性能。
 shadowPath 类型CGPahtRef(指向CGPath的指针) CGPath是一个CoreGraphics对象
 指定 矢量图形，可以通过这个属性单独与图层形状之外设定阴影的形状。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;
@property (weak, nonatomic) IBOutlet UIView *layerView3;
@property (weak, nonatomic) IBOutlet UIView *shadowLayer3; // layerView3的父视图
@property (nonatomic,weak)CALayer * shadowLayer ;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData] ;
}

-(void)initializeData
{
    // 子视图没有被裁剪掉
    self.layerView1.layer.cornerRadius = 20.0f ;
    self.layerView1.layer.borderWidth = 5.0f ;
    self.layerView1.layer.shadowOpacity = 5.0f ;
    self.layerView1.layer.shadowOffset = CGSizeMake(0, 5.0f) ;
    self.layerView1.layer.shadowRadius = 5.0f ;
    
    // 使用裁剪，子视图被裁剪掉，同时阴影也会被裁减掉。
    self.layerView2.layer.cornerRadius = 20.0f ;
    self.layerView2.layer.borderWidth = 5.0f ;
    self.layerView2.layer.shadowOpacity = 0.5f ;
    self.layerView2.layer.shadowOffset = CGSizeMake(0, 5.0f) ;
    self.layerView2.layer.shadowRadius = 5.0f ;
    self.layerView2.layer.masksToBounds = YES ;
    
    self.layerView3.layer.cornerRadius = 20.0f ;
    self.layerView3.layer.borderWidth = 5.0f ;
    self.layerView3.layer.masksToBounds = YES ;
    
    // 设置 layerView3 的父视图为阴影 但是不裁剪
    self.shadowLayer3.layer.cornerRadius = 20.0f ;
    self.shadowLayer3.layer.shadowOpacity = 5.0f ;
    self.shadowLayer3.layer.shadowOffset = CGSizeMake(0, 5.0f) ;
    self.shadowLayer3.layer.shadowRadius = 5.0f ;
    
    
//    self.layerView3.layer.zPosition = 1.0f ;
//    self.shadowLayer = [CALayer layer] ;
//    self.shadowLayer.frame = self.layerView2.frame ;
//    self.shadowLayer.shadowOpacity = 5.0f ;
//    self.shadowLayer.cornerRadius = 5.0f ;
//    self.shadowLayer.shadowOffset = CGSizeMake(0, 5.0f) ;
//    self.shadowLayer.masksToBounds = YES ;
//    [self.layerView3.layer addSublayer:self.shadowLayer] ;
//    [self.shadowLayer addSublayer:self.layerView3.layer] ;
//    [self.view.layer addSublayer:self.shadowLayer] ;
    
}



@end
