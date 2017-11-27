//
//  Zzw_SuspendBallButton.m
//  SuspendBall
//
//  Created by 周泽文 on 2017/7/24.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "Zzw_SuspendBallButton.h"
#import "UIView+Zzw_Positon.h"

static CGFloat fullButtonWidth = 50;
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation Zzw_SuspendBallButton
+(instancetype)sharedInstance{
    static id buttonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        buttonInstance = [[self alloc] init];
    });
    return buttonInstance;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _shouldStickToScreen = YES;
        self.layer.cornerRadius = fullButtonWidth / 2;
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        
        [self addTarget:self action:@selector(suspendBallClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSuspend:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (instancetype)suspendBallWithFrame:(CGRect)ballFrame
                            delegate:(id<Zzw_SuspendBallButtonDelegate>)delegate
                    subBallImagePath:(NSString *)path
{
    if (self) {
        _shouldStickToScreen = YES;
        [self setFrame:ballFrame];
        self.delegate = delegate;
        self.layer.cornerRadius = fullButtonWidth / 2;
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        
        [self addTarget:self action:@selector(suspendBallClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSuspend:)];
        [self addGestureRecognizer:pan];
        
        if ([UIImage imageWithContentsOfFile:path]) {
            [self setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        }else{
            [self setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
        }
    }

    return self;
}

- (void)suspendBallClick:(Zzw_SuspendBallButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickButton:)]) {
        [_delegate clickButton:button];
    }

}

- (void)moveSuspend:(UIPanGestureRecognizer *)pan
{
    NSLog(@"%@",self.superview);
    CGPoint point = [pan locationInView:self.superview];
    
    self.Zzw_centerX = point.x;//将悬浮球中心移动到触点
    self.Zzw_centerY = point.y;
    
    switch (pan.state) {
        case UIGestureRecognizerStateEnded:
            if (point.x < fullButtonWidth / 2) //触点x 小于 左边距为悬浮球一半的宽度
                [UIView animateWithDuration:0.5 animations:^{self.Zzw_x = 0;}];
            
            if ( point.x > KScreenWidth - fullButtonWidth / 2 )//触点x 大于 右边距为悬浮球一半的宽度
                [UIView animateWithDuration:0.5 animations:^{self.Zzw_x = KScreenWidth - fullButtonWidth;}];
            
            
            if (point.y > KScreenHeight - fullButtonWidth / 2)//触点y 小于 底部边距为悬浮球一半的高度
                [UIView animateWithDuration:0.5 animations:^{self.Zzw_y = KScreenHeight - fullButtonWidth;}];
            
            
            if (point.y < 64 + fullButtonWidth / 2)//触点y 小于 顶部边距为悬浮球一半的高度+导航栏的高度
                [UIView animateWithDuration:0.5 animations:^{self.Zzw_y = 64;}];
            
            if (_shouldStickToScreen)
                [self judgeLeftOrRight:pan];
            
            break;
            
        default:
            break;
    }
}

//判断悬浮球拖动结束时在屏幕的哪侧
- (void)judgeLeftOrRight:(UIPanGestureRecognizer *)pan
{
    if (!_shouldStickToScreen) return;
    
    CGPoint endPoint = [pan locationInView:self.superview];
    
    NSTimeInterval interval;
    if (endPoint.x < KScreenWidth / 2){
        interval = 0.5 * endPoint.x/(KScreenWidth/2);
        [UIView animateWithDuration:interval animations:^{self.Zzw_x = 0;}];
    }
    
    if (endPoint.x > KScreenWidth / 2){
        interval = 1 - endPoint.x/(KScreenWidth);
        [UIView animateWithDuration:interval animations:^{self.Zzw_x = KScreenWidth - fullButtonWidth;}];
    }
}

@end
