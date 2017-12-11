//
//  ViewController.m
//  多视图3D变换
//
//  Created by 周泽文 on 16/7/22.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *leftLayerView;
@property (weak, nonatomic) IBOutlet UIView *rightLayerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CATransform3D perspective = CATransform3DIdentity ;
    perspective.m34 = -1.0/500.0 ; // 设置 矩阵 m34的值
    self.view.layer.sublayerTransform  = perspective ;  // 设置 父视图的灭点
    
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0) ;
    self.leftLayerView.layer.transform = transform1 ;
    
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0) ;
    self.rightLayerView.layer.transform = transform2 ;
}



@end
