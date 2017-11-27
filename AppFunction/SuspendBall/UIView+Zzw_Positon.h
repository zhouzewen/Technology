//
//  UIView+Zzw_Positon.h
//  SuspendBall
//
//  Created by 周泽文 on 2017/7/24.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Zzw_Positon)
@property (nonatomic, assign) CGFloat Zzw_width; //self.frame.size.width
@property (nonatomic, assign) CGFloat Zzw_height;//self.frame.size.height

@property (nonatomic, assign) CGFloat Zzw_x;//self.frame.origin.x
@property (nonatomic, assign) CGFloat Zzw_y;//self.frame.origin.y

@property (nonatomic, assign) CGFloat Zzw_centerX;//self.center.x
@property (nonatomic, assign) CGFloat Zzw_centerY;//self.center.y
@end
