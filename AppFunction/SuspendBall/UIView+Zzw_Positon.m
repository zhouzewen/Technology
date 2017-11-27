//
//  UIView+Zzw_Positon.m
//  SuspendBall
//
//  Created by 周泽文 on 2017/7/24.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "UIView+Zzw_Positon.h"

@implementation UIView (Zzw_Positon)
- (CGFloat)Zzw_width
{
    return self.frame.size.width;
}

- (CGFloat)Zzw_height
{
    return self.frame.size.height;
}

- (void)setZzw_width:(CGFloat)Zzw_width
{
    CGRect frame = self.frame;
    frame.size.width = Zzw_width;
    self.frame = frame;
}

- (void)setZzw_height:(CGFloat)Zzw_height
{
    CGRect frame = self.frame;
    frame.size.height = Zzw_height;
    self.frame = frame;
}


- (CGFloat)Zzw_x
{
    return self.frame.origin.x;
}

- (void)setZzw_x:(CGFloat)Zzw_x
{
    CGRect frame = self.frame;
    frame.origin.x = Zzw_x;
    self.frame = frame;
}

- (CGFloat)Zzw_y
{
    return self.frame.origin.y;
}

- (void)setZzw_y:(CGFloat)Zzw_y
{
    CGRect frame = self.frame;
    frame.origin.y = Zzw_y;
    self.frame = frame;
}

- (CGFloat)Zzw_centerX
{
    return self.center.x;
}

- (void)setZzw_centerX:(CGFloat)Zzw_centerX
{
    CGPoint center = self.center;
    center.x = Zzw_centerX;
    self.center = center;
}


- (CGFloat)Zzw_centerY
{
    return self.center.y;
}

- (void)setZzw_centerY:(CGFloat)Zzw_centerY
{
    CGPoint center = self.center;
    center.y = Zzw_centerY;
    self.center = center;
}

@end
