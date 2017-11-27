//
//  TestClass.m
//  TestViewRotation
//
//  Created by 周泽文 on 2017/11/6.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "TestClass.h"
@interface TestClass ()

@end
@implementation TestClass
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
        label.text = @"111";
        [self addSubview:label];
    }
    return self;
}
-(void)testMethod{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
