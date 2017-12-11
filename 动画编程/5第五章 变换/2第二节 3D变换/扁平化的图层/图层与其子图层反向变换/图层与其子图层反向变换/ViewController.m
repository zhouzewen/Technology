//
//  ViewController.m
//  图层与其子图层反向变换
//
//  Created by 周泽文 on 16/7/22.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *outerView;
@property (weak, nonatomic) IBOutlet UIView *innerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CATransform3D outer = CATransform3DIdentity ;
    outer.m34 = -1.0/500.0 ;
    outer = CATransform3DRotate(outer, M_PI_4, 0, 1, 0) ;
    self.outerView.layer.transform = outer ;
    
    CATransform3D inner = CATransform3DIdentity ;
    inner.m34 = -1.0/500.0 ;
    inner = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0) ;
    self.innerView.layer.transform = inner ;
}



@end
