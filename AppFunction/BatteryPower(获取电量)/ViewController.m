//
//  ViewController.m
//  BatteryPower
//
//  Created by 周泽文 on 2017/9/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    //[self testMethod];
    // Do any additional setup after loading the view, typically from a nib.
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive || app.applicationState == UIApplicationStateInactive) {
        Ivar ivar = class_getInstanceVariable([app class], "_statusBar");
        id status = object_getIvar(app, ivar);
        for (id aView in [status subviews]) {
            int batteryLevel = 0;
            for (id bView in [aView subviews]) {
                if ([NSStringFromClass([bView class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame && [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
                    Ivar ivar2 = class_getInstanceVariable([bView class], [@"_accessoryView" UTF8String]);
                    Ivar ivar3 = class_getInstanceVariable([bView class], [@"_capacity" UTF8String]);
                    Ivar ivar4 = class_getInstanceVariable([bView class], "_cachedCapacity");
                    objc_property_t level = class_getProperty([bView class], "_cachedCapacity");
                
                    if (ivar2) {
                        id test = object_getIvar(bView, ivar2);
                        id test3 = [NSString stringWithFormat:@"%@",object_getIvar(bView, ivar4)];
                        id test2 = object_getIvar(bView, ivar3);
                        
                        batteryLevel = (int)test ;
                        
                        //batteryLevel = ((int)(*)(id,Ivar))object_getIvar(bView, ivar2);
                        NSLog(@"电池电量 ： %d",batteryLevel);
                    }
                }
            }
        }
    }
}
-(void)testMethod{
    Person *p = [[Person alloc] init];
    
    Ivar var = class_getInstanceVariable([p class], "_age");
    id age =object_getIvar([p class], var);
    //id name = object_getIvar([p class], var);
    
    NSLog(@"%@",age);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
