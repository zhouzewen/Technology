//
//  ViewController.m
//  ScaleImageView(缩放图片)
//
//  Created by 周泽文 on 2018/3/15.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    _imageView.image = [UIImage imageNamed:@"webRTC建立连接的过程"];
    _imageView.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [_imageView addGestureRecognizer:pinch];
    
    [self.view addSubview:_imageView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)scaleImage:(UIPinchGestureRecognizer *)pinch{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    UIView *view = pinch.view;
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinch.scale, pinch.scale);
        pinch.scale = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
