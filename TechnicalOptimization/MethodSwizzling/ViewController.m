//
//  ViewController.m
//  MethodSwizzling
//
//  Created by 周泽文 on 2017/7/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "NSString+ZzwAdditions.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     1 给NSString 添加一个分类的方法 Zzw_myLowercaseString
     2 将 Zzw_myLowercaseString 和 lowercaseString 做交换
     */
    Method originMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method swappedMethod = class_getInstanceMethod([NSString class], @selector(Zzw_myLowercaseString));
    method_exchangeImplementations(originMethod, swappedMethod);
    
    NSString *string = @"This is The StRing";
    NSString * lowercaseString = [string lowercaseString];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
