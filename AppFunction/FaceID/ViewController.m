//
//  ViewController.m
//  FaceID
//
//  Created by 周泽文 on 2018/1/4.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//
/**
 1 去info.plist文件中注册 faceID功能
 Privacy - Face ID Usage Description 此 App 需要您的同意才能使用FaceID
 2 project -> Build Phases -> Link Binary With Libraries 导入 LocalAuthentication.framework
 3  #import <LocalAuthentication/LocalAuthentication.h>
 4 写代码 实现
 
 参考资料
 http://blog.csdn.net/xinkongqishf/article/details/78491584
 https://www.jianshu.com/p/571fc7e29a9a
 */
#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 300, 100)];
    [button setTitle:@"开始face检测" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(faceDetect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)faceDetect{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    __block UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 300, 50)];
    BOOL condition = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (condition) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"333" reply:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"%s %@",__func__,[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil == error) {
                    label.text = @"验证通过，你好帅";
                    [self.view addSubview:label];
                }else{
                    label.text = @"验证失败，这个脸太挫了";
                    [self.view addSubview:label];
                    NSLog(@"error : %@",error);
                }
            });
            
        }];
    }else{
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
