//
//  ViewController.m
//  ButtonActionWithRuntime
//
//  Created by CivetDev on 2017/6/12.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#include "UIButton+Action.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * button1 = [UIButton createBtnWithFrame:CGRectMake(100, 100, 100, 50) title:@"button1" actionBlock:^(UIButton *button) {
        float r = random()%255/255.0 ;
        float g = random()%255/255.0 ;
        float b = random()%255/255.0 ;
        self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    }] ;
    button1.backgroundColor = [UIColor lightGrayColor] ;
    [self.view addSubview:button1] ;
    
    UIButton * button2 = [UIButton createBtnWithFrame:CGRectMake(100, 200, 100, 50) title:@"button2" actionBlock:nil] ;
    button2.actionBlock = ^(UIButton *button) {
        NSLog(@"===%@=====",button.currentTitle) ;
    } ;
    button2.backgroundColor = [UIColor lightGrayColor] ;
    [self.view addSubview:button2] ;
    
    
    [self getiOSPrivateAPI] ;
}

-(void)getiOSPrivateAPI
{
    NSString * className = NSStringFromClass([UIView class]) ;
    const char * cClassName = [className UTF8String] ;
    id theClass = objc_getClass(cClassName) ;
    unsigned int outCount ;
    Method * m = class_copyMethodList(theClass, &outCount) ;
    NSLog(@"%d",outCount) ;
    for (int i = 0; i < outCount; i++) {
        SEL a = method_getName(*(m+i)) ;
        NSString * sn = NSStringFromSelector(a) ;
        NSLog(@"%@",sn) ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
