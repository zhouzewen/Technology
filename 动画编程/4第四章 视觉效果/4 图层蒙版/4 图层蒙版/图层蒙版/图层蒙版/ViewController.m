//
//  ViewController.m
//  图层蒙版
//
//  Created by fox/周泽文 on 16/7/20.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  图层蒙版
/*********************************************
    通过 masksToBounds，可以沿着边界裁剪图形，
    通过 cornerRadius，可以设定一个圆角。
    使用一个32位有alpha通道的png图片，通常是创建一个无矩形视图的最方便的方法
    指定一个透明的蒙版来实现。但此方法无法以编码的方式动态地生成蒙版，也无法
    让子图层或子视图裁剪成同样的形状。
 
    CALayer 有一个属性叫做mask，类型是 CALayer 
    和其他图层一样有绘制和布局属性，它类似于一个子图层相对父图层布局。但它不是
    普通的子图层，mask图层定义了父图层的部分可见区域。
 
    mask图层的color属性不重要，图层的轮廓最重要，mask属性像饼干切割机，mask
    图层包括的部分会被保留，其余抛弃。
    若mask图层比父图层小，只有mask图层中的内容才是它关心的，除了mask图层中的内容
    其余都会被隐藏。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建一个 图层
    CALayer * maskLayer = [CALayer layer] ;
    maskLayer.frame = self.imageView.bounds ; // 初始化图层的frame
    UIImage *maskImage = [UIImage imageNamed:@"Cone"] ;
    maskLayer.contents = (__bridge id)maskImage.CGImage ; // 为图层添加寄宿图
    
    // 将创建的图层 赋值给 imageView.layer.mask
    // 这样，imageView就会按照 mask的形状做裁剪
    // imageView 原来的图片内容是一个 冰屋，但是mask的形状是圆锥安全桶
    // 所以会裁剪出一个圆锥安全桶的形状，但是颜色还是冰屋
    self.imageView.layer.mask = maskLayer ;
}



@end
