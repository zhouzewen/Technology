//
//  ViewController.m
//  圆角
//
//  Created by fox/周泽文 on 16/7/19.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  圆角
/*********************************************
 1.主屏幕图标 警告框 文本框 都是圆角
 2.CALayer.cornerRadius 控制图层角的曲率，浮点数 默认为0(直角)
 此值只影响背景色而不影响背景图片或子图层。
 但把masksToBounds设置为YES，则图层里所有的东西都会被截取。
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
    // set corner radius on layers
    self.layerView1.layer.cornerRadius = 20.0f ;
    self.layerView2.layer.cornerRadius = 20.0f ;
    
    // enable clipping on layerView2 layer
    self.layerView2.layer.masksToBounds = YES ;
}



@end
