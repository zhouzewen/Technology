//
//  TestClass.m
//  WKWebView&JS
//
//  Created by 周泽文 on 2018/1/20.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass

+(void)testClas{
    NSString *str = @"123";
    str = [str stringByAppendingString:@"456"];
    NSLog(@"str %@",str);
}
@end
