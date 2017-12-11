//
//  ViewController.m
//  3DCube
//
//  Created by 周泽文 on 16/7/23.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h> // 导入GLKit 计算光线和阴影
#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *faces;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    [self createCube] ; // 创建 立方体的六个面
    [self forbidOtherFace] ; // 禁止 面3 之外其他界面的点击事件
//    [self moveFace3OverFace6] ; // 将面3改为最后一个添加，面的添加顺序变为124563
}
-(void)createCube
{
    //    self.containerView.frame = self.view.frame ;
    //    [self.view addSubview:self.containerView] ;
    self.view.backgroundColor = [UIColor redColor] ;
    self.containerView.backgroundColor = [UIColor grayColor] ;
    CATransform3D perspective = CATransform3DIdentity ;
    perspective.m34 = -1.0/500.0 ;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0) ;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0) ;
    self.containerView.layer.sublayerTransform = perspective ;
    
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
    UIView *face = self.faces[index] ;
    [self.containerView addSubview:face] ;
    CGSize containerSize = self.containerView.frame.size ;
    face.center = CGPointMake(containerSize.width/2.0, containerSize.height/2.0) ;
    face.layer.transform = transform ;
    face.layer.doubleSided = NO ;// 不绘制背面
//    face.layer.doubleSided = YES ;
    [self applyLightingToFace:face.layer] ; // 为图层添加光线和阴影效果
}

#pragma mark - 计算光线和阴影
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
- (IBAction)ClikCubeFace3:(id)sender
{
    NSLog(@"点击了立方体表面3") ;
}


//延伸讨论
/***********************************
 1.立方体表面3上放的是一个按钮，可以为按钮连线 添加事件，但是点击之后没有响应。
 2.这是因为，在添加立方体的面的时候，是按照123456的顺序来添加的。
 所以3的后面还有456三个视图，这三个视图会截断3的点击事件。
 3解决方案
    第一种是 把除了3之外的其他视图的userInteractionEnabled设置为NO
    第二种是 通过代码把3覆盖在6上。
 ***********************************/

// 第一种方式
-(void)forbidOtherFace
{
    // 禁止 456 三个面的点击事件
//    UIView *face4 = self.faces[3] ; // 面4
//    face4.userInteractionEnabled = NO ;
//    
//    UIView * face5 = self.faces[4] ;
//    face5.userInteractionEnabled = NO ;
//    
//    UIView * face6 = self.faces[5] ;
//    face6.userInteractionEnabled = NO ;
    
    // 禁止 除了3 以外其他面的点击事件
    for (int  i = 0 ; i < self.faces.count ; i++)
    {
        if (i == 2) // 面3
        {
            continue ; // 跳过本次循环
        }
        UIView * face = self.faces[i] ;
        face.userInteractionEnabled = NO ;
    }
    
}

-(void)moveFace3OverFace6
{
    UIView * face3  = self.faces[2] ; // 面3
//    UIView * face6  = self.faces[5] ; // 面6
//    [self.containerView addSubview:face6] ;
    // 因为storyboard中已经按顺序添加了123456 留个面
    // 这里用代码在添加一次，就改变了顺序了，face3会被最后一个添加到界面上
    // 顺序就改为了 124563 ，不需要先拿到face6添加，然后在添加face3
    [self.containerView addSubview:face3] ;
//    [face6 addSubview:face3] ; // 错误的做法
}
@end
