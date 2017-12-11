//
//  ViewController.m
//  重复图层
//
//  Created by 周泽文 on 16/7/31.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

//CAReplicatorLayer
/***********************************
 1.CAReplicatorLayer 可以高效生成许多相似的图层
 绘制一个或多个图层的子图层，在每个复制体上做不同的变换。
 
 ***********************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData] ;
}

-(void)initializeData
{
//    self.containerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
//    self.containerView.frame = CGRectMake(0, 0, 200, 200) ;
    CAReplicatorLayer * replicator = [CAReplicatorLayer layer] ;
    replicator.frame = self.containerView.bounds ;
    [self.containerView.layer addSublayer:replicator] ;
//    replicator.frame = self.view.bounds ;
//    [self.view.layer addSublayer:replicator] ;
    
    replicator.instanceCount = 10 ; // 10个复制
    CATransform3D transform = CATransform3DIdentity ;
    transform = CATransform3DTranslate(transform, 0, 40, 0) ;
    transform = CATransform3DRotate(transform, M_PI/5.0, 0, 0, 1) ;
    transform = CATransform3DTranslate(transform, 0, -40, 0) ;
    replicator.instanceTransform = transform ;
    replicator.instanceBlueOffset = -0.1 ;
    replicator.instanceGreenOffset = - 0.1 ;
    
    CALayer * layer = [CALayer layer] ;
    layer.frame = CGRectMake(100, 100, 50, 50) ;
    layer.backgroundColor = [UIColor whiteColor].CGColor ;
    [replicator addSublayer:layer] ;
    
    // 最后图形形成的效果和 replicator的frame有关
}

@end
