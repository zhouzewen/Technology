//
//  Person.m
//  AppFunction
//
//  Created by 周泽文 on 2017/9/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "Person.h"
@interface Person(){
    NSString *_name;
    int _age;
}

@end
@implementation Person
-(instancetype)init{
    self = [super init];
    if (self) {
        _name = @"zhouzewen";
        _age =27;
    }
    return self;
}
@end
