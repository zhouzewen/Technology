//
//  TabBarController.m
//  图层树动画
//
//  Created by fox/周泽文 on 16/8/11.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    CATransition * transition = [CATransition animation] ; // 设置过渡动画
    transition.type = kCATransitionFade ; // 设置切换taBar的效果为 淡入淡出
//    transition.type = kCATransitionPush ;
//    transition.subtype = kCATransitionFromTop ;
    [self.view.layer addAnimation:transition forKey:nil] ;
}
@end
