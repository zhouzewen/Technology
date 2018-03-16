//
//  ZZW_ScollViewController.m
//  ScaleImageView(缩放图片)
//
//  Created by 周泽文 on 2018/3/15.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "ZZW_ScollViewController.h"
#define minScale 1
#define maxScale 2
@interface ZZW_ScollViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation ZZW_ScollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.contentSize = self.view.frame.size;
    _scrollView.delegate = self;
    [_scrollView setMinimumZoomScale:minScale];
    [_scrollView setMaximumZoomScale:maxScale];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    _imageView.image = [UIImage imageNamed:@"webRTC建立连接的过程"];
    [_scrollView addSubview:_imageView];
    
    [self.view addSubview:_scrollView];
    // Do any additional setup after loading the view.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"scale is %f",scale);
    [_scrollView setZoomScale:scale animated:NO];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"===== scale is %f",scrollView.zoomScale);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
