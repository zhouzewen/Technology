//
//  ViewController.m
//  同一视角不同变换的立方体
//
//  Created by 周泽文 on 16/7/28.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//


/***********************************
 Core Animation 图层很容易就可以让你在2D环境下独立地移动每个区域，
 但是3D情况就不太可能，因为所有的图层都把其子图层压缩在一个平面上。
 
 CATransformLayer 解决了这个问题。CATransformLayer不能显示自己的内容，
 只有当存在一个能作用于子图层的变换的时候，CATransformLayer才存在。
 
 CATransformLayer不会平面化其子图层，可以用来构造一个层级的3D结构。
 第五章的立方体代码中，使用了sublayerTransform解决图层平面化问题，
 但是这个技巧只能作用于单个对象上，如果有两个立方体就不能用这个技巧了。
 
 此时，我们将通过旋转camara，来解决图层平面化问题。
 
 ***********************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CATransform3D pt = CATransform3DIdentity ;
    pt.m34 = -1.0/500.0 ;
    self.containerView.layer.sublayerTransform = pt ;
    
    CATransform3D c1t = CATransform3DIdentity ;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0) ;
    CALayer * cube1 = [self cubeWithTransform:c1t] ;
    [self.containerView.layer addSublayer:cube1] ;
    
    CATransform3D c2t = CATransform3DIdentity ;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0) ;
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0) ;
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0) ;
    CALayer * cube2 = [self cubeWithTransform:c2t] ;
    [self.containerView.layer addSublayer:cube2] ;
}

-(CALayer *)faceWithTransform:(CATransform3D) transform
{
    CALayer * face = [CALayer layer] ;
    face.frame = CGRectMake(-50, -50, 100, 100) ;
    
    // rand() 产生一个随机数的函数  INT_MAX 整型数值的最大值
    CGFloat red = (rand()/(double)INT_MAX) ;
    CGFloat green = (rand()/(double)INT_MAX) ;
    CGFloat blue = (rand()/(double)INT_MAX) ;
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor ;
    face.transform = transform ;
    return face ;
}

-(CALayer *)cubeWithTransform:(CATransform3D)transform
{
    CATransformLayer * cube = [CATransformLayer layer] ;

    // face1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50) ;
    [cube addSublayer:[self faceWithTransform:ct]] ;
    
    // face2
    ct = CATransform3DMakeTranslation(50, 0, 0) ;
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0) ;
    [cube addSublayer:[self faceWithTransform:ct]] ;
    
    // face3
    ct = CATransform3DMakeTranslation(0, -50, 0) ;
    ct = CATransform3DRotate(ct,  M_PI_2, 1, 0, 0 ) ;
    [cube addSublayer:[self faceWithTransform:ct]] ;
    
    ct = CATransform3DMakeTranslation(0, 50, 0) ;
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0) ;
    [cube addSublayer:[self faceWithTransform:ct]] ;
    
    ct = CATransform3DMakeTranslation(-50, 0, 0) ;
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0) ;
    [cube addSublayer:[self faceWithTransform:ct]] ;
    
    ct = CATransform3DMakeTranslation(0, 0, -50) ;
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0) ;
    [cube addSublayer:[self faceWithTransform:ct]] ;
    
    CGSize containerSize = self.containerView.bounds.size ;
    cube.position = CGPointMake(containerSize.width/2.0, containerSize.height/2.0) ;
    cube.transform = transform ;
    return cube ;
}
@end
