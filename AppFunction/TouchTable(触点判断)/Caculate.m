//
//  Caculate.m
//  DelegateTest
//
//  Created by 周泽文 on 2017/7/4.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "Caculate.h"

@implementation Caculate
+(locationInCurrentView)locationInView:(UIView*)view withPoint:(CGPoint)point{
    CGFloat width = view.frame.size.width;
    if (point.x > width/2) {
        return right;
    }
    return left;
}
@end
