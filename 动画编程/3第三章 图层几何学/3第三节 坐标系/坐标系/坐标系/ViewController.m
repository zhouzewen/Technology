//
//  ViewController.m
//  坐标系
//
//  Created by fox/周泽文 on 16/7/16.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  坐标系
/*********************************************
 1.同视图一样，图层在图层树中也是相对于父图层来放置的。
 2.一个图层的position依赖于父图层的bounds，父图层发生了移动，所有子图层也会跟着移动。
 3.可以通过移动父图层，来把其包含的子图层作为整体移动。
 4. UIView 是二维平面坐标系，通过x,y两个参数来确定位置
 *********************************************/

//  三维坐标
/*********************************************
 1. iOS中  图层的position 相对于 父图层的 左上角
   MacOS 图层的position 相对于 父图层的 左下角
 2.UIView是严格的二维坐标系，CALayer是三维坐标系
 CALayer除了 position anchorPoint 两个属性之外，还有 zPosition anchorPointZ 两个属性
 这两个属性都是Z轴上描述图层位置的浮点类型。
 *********************************************/

//  zPosition
/*********************************************
 1.zPosition 最实用的功能就是改变图层的显示顺序
 通常图层是根据子图层的sublayers出现的顺序来绘制的，但是zPosition可以将后面的图层置前。
 2.<#secondContent#>
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;
}

-(void)initializeData
{
    // 视图都是根据创建的先后顺序来显示的，后添加的会覆盖在之前添加的上面。
    NSLog(@"%f",self.redView.layer.zPosition) ; // 初值都是 0
    NSLog(@"%f",self.blueView.layer.zPosition) ;// 初值都是 0
    
    // 视图都非常的薄，所以只需要给zPosition 提高一个像素就可以让后面的视图前置
    // 赋值 0.1 0.0001也能够办到，但是浮点类型会四舍五入，计算会有些麻烦。
    // 所以一般赋值为整数。
    self.redView.layer.zPosition = 1.0f ;
}



@end
