//
//  ViewController.m
//  Custom Drawing
//
//  Created by fox/周泽文 on 16/7/18.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  为图层 添加 寄宿图
/*********************************************
 1.给图层的contents赋值
 2.使用Core Graphics 直接绘制寄宿图
 *********************************************/

//  drawRect方法
/*********************************************
 1.-drawRect方法没有默认的实现，因为对于UIView而言，寄宿图不是必须的。
 如果UIView检测到-drawRect方法被实现了，UIView会添加一个寄宿图，这个
 寄宿图的像素尺寸等于视图的大小乘contentsScale的值。
 如果不需要寄宿图，就不要实现-drawRect方法，会浪费CPU和内存
 
 2.视图出现在屏幕上，-drawRect方法会被自动调用，利用Core Graphics 去绘制
 寄宿图，内容会被缓存起来，直到需要更新(一般是-setNeedsDisplay 被调用)
 
 3.-drawRect是UIView方法，但都是底层的CALayer安排了重绘工作和保存产生的图片
 *********************************************/

//  CALayer.delegate
/*********************************************
 1.  非正式协议,不需要再.h文件中 遵守协议
 2.  .m文件中 设置代理为 self
 3.  直接调用代理的方法(都是optional)
 *********************************************/


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData]; // initial view
}

-(void)initializeData
{
    CALayer * layer = [CALayer layer] ; // create subLayer
    layer.frame = CGRectMake(50, 50, 200, 200) ;
    layer.backgroundColor = [UIColor cyanColor].CGColor ;
    layer.delegate = self ; // set controller as layer delegate
    layer.contentsScale = [UIScreen mainScreen].scale ; // ensure that layer backing image uses correct scale
    [self.view.layer addSublayer:layer] ; // add layer to our view
    [layer display] ; // force layer to redraw
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    // draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f) ; // set circle line with
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor) ; // set circle line color
    CGContextStrokeEllipseInRect(ctx, layer.bounds) ; //set circle frame
}

//  两个特别点
/*********************************************
 1.layer 显式调用了 -display
 CALayer不会自动重绘其内容，开发者需要自己决定。UIView会自己重绘。
 2.圆的边间被裁剪了，虽然没有使用masksToBounds，但是绘制寄宿图时
 没有对超出边界的内容提供绘制支持。
 *********************************************/

//  summary
/*********************************************
 1.除非单独创建一个 图层，否则几乎不会用到CALayerDelegate
 因为UIView创建图层时，会自动把图层的delegate设置为自己，
 并提供-displayLayer的实现。
 2.在使用视图的图层时，也不必实现-displayLayer 和 -drawLayer:inContext:
 来绘制寄宿图。通常是实现UIView的-drawRect: UIView会自己完成其余工作
 包括在需要重绘的时候调用-display
 *********************************************/
@end
