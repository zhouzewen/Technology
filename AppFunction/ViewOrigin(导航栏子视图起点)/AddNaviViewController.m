//
//  AddNaviViewController.m
//  ViewFrameOrigin
//
//  Created by 周泽文 on 2017/8/5.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "AddNaviViewController.h"
#import "TestViewController.h"
@interface AddNaviViewController ()

@end

@implementation AddNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AddNaviViewController.h";
    /**
     1 不设置背景色 屏幕就会是黑的
     2 @property(nonatomic,assign) UIRectEdge edgesForExtendedLayout NS_AVAILABLE_IOS(7_0); // Defaults to UIRectEdgeAll 
     self.view的起点是在导航栏的顶部，而导航栏的视图层级在最上面，会遮挡view上的内容
     UIRectEdgeNone self.view的起点就会设置在 导航栏底部
     */
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(90, 64, 100, 20)];
    label.text = @"333";
    label.textColor = [UIColor cyanColor];
    [self.view addSubview:label];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Zzw_pushNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)Zzw_pushNextView{
    TestViewController * ctr = [[TestViewController alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}

@end
