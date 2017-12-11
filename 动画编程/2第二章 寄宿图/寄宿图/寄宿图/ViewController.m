//
//  ViewController.m
//  寄宿图
//
//  Created by fox/周泽文 on 16/7/15.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  寄宿图
/*********************************************
 1.UIView  视图    self.view.layer  图层
 2.图层中可以包含图片，这个图片就是寄宿图
 *********************************************/

//  CALayer的属性  1.contents
/*********************************************
 类型 id
 但是如果给layer.contents 赋值 不是CGImage，虽然编译可以通过，但是图层是没有图片的。
 MacOS平台上，layer.contents 可以使 CGImage 或 NSImage ， iOS 只能是 CGImage
 UIImage 有一个 CGImage属性，此属性返回 CGImageRef，但是如果直接把这个值 赋给
 CALayer 的 contents属性，编译会提示错误。CGImageRef 是一个 Core Foudation类型
 不是 Cocoa对象，需要对CGImageRef做bridged转换(ARC中)。MRC是不需要__bridge转换的。
 layer.contes = (__bridge id)image.CGImage
 *********************************************/

//CALayer的属性   2.contentGravity
/***********************************
 在图层(CALayer)中添加的图片可能会被拉伸或压缩，同UIImageView一样的道理。
 UIImageView 中 view.contentMode = UIViewContentModeScaleAspectFit
 CALayer中，对应的属性是contentsGravity，类型 NSString  可选的常量
 kCAGravityCenter
 kCAGravityTop
 kCAGravityBottom
 kCAGravityLeft
 kCAGravityRight
 kCAGravityTopLeft
 kCAGravityTopRight
 kCAGravityBottonLeft
 kCAGravityBottonRight
 kCAGravityResize
 kCAGravityResizeAspect  等效于 UIViewContentModeScaleAspectFit
 kCAGravityResizeAspectFill
 ***********************************/


//CALayer的属性   3.contentsScale
/***********************************
 寄宿图像素尺寸 和 视图大小的比例，默认为1.0f
 当寄宿图设置了contentsGravity属性时，再设置contentScale是无效的。
 contentScale属性，是支持高分辨率屏幕机制的一部分，可以来判断绘制
 图层的时候应该为寄宿图创建的空间大小，和需要显示图片的拉伸度(没有设置contentGravity)
 UIView有类似的功能，contentScaleFactor属性，但非常少用到。
 如果contentsScale = 1.0  每个点 一个像素绘制图片
 contentsScale = 2.0  每个点 两个像素绘制图片(Retina屏幕)
 这样设置不会对使用kCAGravityResizeAspect产生影响，但当把contentsGravity设置为kCAGravityCenter
 会
 ***********************************/


//CALayer的属性   4. masksToBounds
/***********************************
 默认情况下，UIView仍然会绘制超过边间的内容或子视图，CALayer亦如此
 UIView有一个叫 clipsToBounds的属性来决定是否显示超出边界的内容，
 CALayer的属性则是masksToBounds  设置为YES 则会剪切掉超出的部分
 ***********************************/


//CALayer的属性    5. contentsRect
/***********************************
 CALayer的contentsRect属性，能在图层的边框中显示寄宿图的子域，
 contentsRect和 bounds frame 不同，不是按照点来计算的，使用的是单位坐标
 0~1之间，是相对值。
 
 点  ： iOS 和 MacOS中 最常见的坐标体系。点是虚拟的像素，也叫逻辑像素。
 在标准的设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2个像素。
 iOS用点作为屏幕的坐标测算体系，是为了在Retina设备和普通设备上能有一致的视觉效果。
 
 像素：物理像素，坐标不会用屏幕布局，当仍与图片有相对关系，UIImage是一个屏幕
 分辨率解决方案，置顶点来度量大小。一些底层的图片如CGImage会使用像素。
 
 单位： 比例值，0~1，0代表没有，1代表相同大小，0.5代表一半。类似的有红绿蓝三色，
 可以用0~1之间的三个值来表示，也可以用0~255表示然后/255，当然也可以用16进制表示。
 
 默认的contentsRect是{0,0,1,1} 即整个寄宿图可见。 {0,0,0.5,0.5} 左上的四分之一张图片可见。
 contentsRect设置为负数的原点 或者 大于{1，1}尺寸也可以。此时，最外面的像素会被拉伸来
 填充剩下的区域。
 contentsRect可以用来拼接图片，拼接的图片可以一次性载入，和多次加载小图相比，
 可以减少内存使用，载入的时间，提高渲染性能。
 2D游戏引擎Cocos2D使用了拼接技术，用OpenGL来显示图片。UIKit则用contentsRect来拼接。 
 ***********************************/


//CALayer的属性   6. contentsCenter
/***********************************
 类型  CGRect
 定义了一个固定的边框和一个在图层上可拉伸的区域。
 改变contentsCenter的值不会影响到寄宿图的显示，除非这个图层的大小改变。
 默认contentsCenter是{0,0,1,1}，表示寄宿图的大小(由contentsGravity决定)改变，
 那么寄宿图会均匀地拉伸开。但若改变contentsCenter的值，会在寄宿图周围创建边框。
 ***********************************/
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;
    
}

-(void)initializeData
{
    UIImage *image = [UIImage imageNamed:@"全宝蓝"] ;
    
    CALayer * layer = [CALayer layer] ; // 创建图层
    layer.frame = CGRectMake(30, 50, 250, 200) ;
    layer.contents = (__bridge id)image.CGImage ; // 给图层 添加寄宿图
    //    layer.contentsGravity = kCAGravityResizeAspect ; // 拉伸图片适应 图层的frame
    layer.contentsGravity = kCAGravityCenter ; //
    //    layer.contentsScale = 1.0 ; //
    //    layer.contentsScale = image.scale ;  等价于1.0
    //    layer.contentsScale = 2.0 ; // Retina 屏幕
    layer.contentsScale = [UIScreen mainScreen].scale ; // 等价于 2.0, 因为默认的都是Retina屏
    [self.view.layer addSublayer:layer] ; // 在self.view的 图层上 添加 创建的图层作为子图层
}


@end
