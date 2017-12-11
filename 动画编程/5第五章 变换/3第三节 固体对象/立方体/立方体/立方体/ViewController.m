//
//  ViewController.m
//  立方体
//
//  Created by 周泽文 on 16/7/22.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5
@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *CubeFaces;


@end


//视图旋转的左手定则
/***********************************
 1.左手大拇指和其余四指垂直
 2.大拇指方向代表正方向，四指握拳的方向就是顺时针方向，
 也就是旋转角度代表的正值。
 ***********************************/
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor] ;
    // 设置 容器视图 sublayer transform 让六个视图有统一的灭点
    CATransform3D perspective = CATransform3DIdentity ;
    perspective.m34 = -1.0/500.0 ;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0) ; // 沿着 x轴逆时针 旋转45°
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0) ; // 沿着 y轴逆时针 旋转45°
    self.view.layer.sublayerTransform = perspective ;
    
    // 设置正方体面1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100) ; // 沿着z轴移动100个点
    [self addFace:0 withTransform:transform] ;
    
    // 设置正方体面2
    transform = CATransform3DMakeTranslation(100, 0, 0) ; // 沿着 x 轴移动100个点
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0) ;// 沿着y轴 顺时针旋转90°
    [self addFace:1 withTransform:transform] ;
    
    // 设置正方体面3
    transform = CATransform3DMakeTranslation(0, -100, 0) ; // 沿着y轴负方向 移动100个点
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0) ; //沿着x轴 顺时针旋转90°
    [self addFace:2 withTransform:transform] ;
    
    // 设置正方体面4
    transform = CATransform3DMakeTranslation(0, 100, 0) ; // 沿着 y轴正方向 移动100个点
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0) ; // 沿着 x轴逆时针 旋转90°
    [self addFace:3 withTransform:transform] ;
    
    // 设置正方体面5
    transform = CATransform3DMakeTranslation(-100, 0, 0) ; // 沿着 x轴负方向 移动100个点
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0)  ; //沿着 y轴逆时针 旋转90°
    [self addFace:4 withTransform:transform] ;
    
    // 设置正方体面6
    transform = CATransform3DMakeTranslation(0, 0, -100) ; // 沿着 z轴负方向 移动100个点
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0) ; // 沿着 y轴逆时针 旋转 180°
    [self addFace:5 withTransform:transform] ;
}

-(void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    UIView *face = self.CubeFaces[index] ;
    [self.view addSubview:face] ;
    face.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0) ;
    face.layer.transform = transform ;
    [self applyLightingToFace:face.layer] ;
}

-(void)applyLightingToFace:(CALayer *)face
{
    CALayer * layer = [CALayer layer] ;
    layer.frame = face.bounds ;
    [face addSublayer:layer] ;
    CATransform3D transform = face.transform ;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform ;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4) ;
    
    GLKVector3 normal = GLKVector3Make(0, 0, 1) ;
    normal = GLKMatrix3MultiplyVector3(matrix3, normal) ;
    normal = GLKVector3Normalize(normal) ;
    
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION)) ;
    float dotProduct = GLKVector3DotProduct(light, normal) ;
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT ;
    
    UIColor * color = [UIColor colorWithWhite:0 alpha:shadow] ;
    layer.backgroundColor = color.CGColor ;
}
@end
