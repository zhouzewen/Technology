//
//  ViewController.m
//  拼接图片
//
//  Created by fox/周泽文 on 16/7/15.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *topLeftView;
@property (weak, nonatomic) IBOutlet UIView *topRightView;
@property (weak, nonatomic) IBOutlet UIView *bottomLeftView;
@property (weak, nonatomic) IBOutlet UIView *bottomRightView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initializeData] ;
    
}

-(void)initializeData
{
    self.view.backgroundColor = [UIColor cyanColor] ;
    UIImage * image = [UIImage imageNamed:@"全宝蓝"] ;
    [self addLayerImage:image withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:self.topLeftView.layer] ;
    [self addLayerImage:image withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:self.topRightView.layer] ;
    [self addLayerImage:image withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:self.bottomLeftView.layer] ;
    [self addLayerImage:image withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayer:self.bottomRightView.layer] ;
}
-(void)addLayerImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)image.CGImage ;
    layer.contentsGravity = kCAGravityResizeAspect ;
    layer.contentsRect = rect ;
}




@end
