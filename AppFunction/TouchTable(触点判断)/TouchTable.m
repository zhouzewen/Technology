//
//  TouchTable.m
//  DelegateTest
//
//  Created by 周泽文 on 2017/7/4.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "TouchTable.h"

@implementation TouchTable
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    [super hitTest:point withEvent:event];
    if (self.touchDelegate) {
        [self.touchDelegate fingerTouchPoint:point];
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint ponit = [touch locationInView:self];
    [super touchesBegan:touches withEvent:event];
//    if (self.touchDelegate ) {
//        [self.touchDelegate fingerTouchPoint:ponit];
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
