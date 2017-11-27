//
//  FPS_Label.m
//  FPS_Caculate
//
//  Created by 周泽文 on 2017/7/8.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "FPS_Label.h"

@implementation FPS_Label {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    NSLog(@"%ld",self.retainCount);
    return self;
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    NSLog(@"%s",__func__);
    NSLog(@"%ld",self.retainCount);
    [_link invalidate];
    NSLog(@"%ld",self.retainCount);
}
-(void)dealloc{
    NSLog(@"%s",__func__);
    NSLog(@"%ld",self.retainCount);
    [super dealloc];
}

- (void)tick:(CADisplayLink *)link {
    
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    self.attributedText = text;
    NSLog(@"FPS %d",(int)round(fps));
}


@end
