//
//  SecondViewController.m
//  图层树动画
//
//  Created by fox/周泽文 on 16/8/13.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.title = NSLocalizedString(@"Second", @"Second") ;
    self.tabBarItem.image = [UIImage imageNamed:@"second"] ;
    
}
@end
