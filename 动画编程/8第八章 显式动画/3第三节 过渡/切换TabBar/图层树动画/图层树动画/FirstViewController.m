//
//  FirstViewController.m
//  图层树动画
//
//  Created by fox/周泽文 on 16/8/13.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.title = NSLocalizedString(@"First", @"First") ;
    self.tabBarItem.image = [UIImage imageNamed:@"first"] ;
}
@end
