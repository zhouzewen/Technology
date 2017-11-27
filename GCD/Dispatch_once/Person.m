//
//  Person.m
//  Dispatch_once
//
//  Created by 周泽文 on 2017/6/21.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "Person.h"

@implementation Person

static Person * person = nil;
+(Person *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        person = [[self alloc] init] ;
    });
    return person ;
}
@end
