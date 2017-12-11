//
//  ViewController.m
//  布局属性
//
//  Created by fox/周泽文 on 16/7/16.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  图层几何--布局
/*********************************************
 1.UIView有三个属性:frame、bounds、center，都可以用来布局,调整视图的大小和位置
 
 2.CALayer也有对应的三个，fame bounds position，
 
 3. 视图 center  和 图层的 position 代表了同样的值
 *********************************************/

//  三个布局属性的含义
/*********************************************
 1.frame 代表了图层的外部坐标(在父图层中的位置)
 2.bounds 代表了内部坐标,{0,0}是图层的左上角
 3.center/position 都代表了相对于父图层anchorPoint所在的位置。
 *********************************************/

//  改变视图布局属性的本质
/*********************************************
 1.视图的frame,bounds,center 仅仅是存取方法，当操纵视图的frame时，实际上是在改变
 视图对应图层(CALayer)的frame。
 
 2.对视图 或 图层 而言，frame是一个虚拟的属性，它由bounds,position,transform计算得到
 故三者任何一个有改变，frame都会变化。同样frame的改变也会影响到三者的值。
 
 3.当图层做变换时，如旋转或缩放，frame实际上代表了能够包含图层旋转之后的整个矩形区域。
 此时frame的宽高可能和bounds的宽高不同了。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
