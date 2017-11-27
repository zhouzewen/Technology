//
//  AppDelegate.m
//  BackgroundTime(申请后台时间)
//
//  Created by 周泽文 on 2017/11/3.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()
@property(nonatomic,assign)UIBackgroundTaskIdentifier backgroundTaskInvalid;
@property(nonatomic,assign)NSTimeInterval tenMinute;
@property(nonatomic,assign)NSTimeInterval timerSecond;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *taskIdArray;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    self.tenMinute = 0.0f;
    self.taskIdArray = @[].mutableCopy;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self beginBackground];
}
-(void)beginBackground{
    if (self.tenMinute >= 600) {
        return;
    }
    self.backgroundTaskInvalid = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (self.tenMinute < 600) {
            NSLog(@"申请时间完毕，再次申请或到达十分钟不再申请");
            [self beginBackground];
        }
    }];
    [self.taskIdArray addObject:@(self.backgroundTaskInvalid)];
    self.tenMinute = self.tenMinute + [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"剩余时间:%f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(test) userInfo:nil repeats:YES];
    
}
-(void)test{
    NSLog(@"监控时间：%@",[NSDate date]);
    self.timerSecond++;
    if (self.timerSecond >= 600) {
        [self.taskIdArray enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"taskId ==== %lu",(unsigned long)obj.unsignedIntegerValue);
            [[UIApplication sharedApplication] endBackgroundTask:obj.unsignedIntegerValue];
        }];
        self.backgroundTaskInvalid = UIBackgroundTaskInvalid;
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
