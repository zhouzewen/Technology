//
//  TestClass.m
//  OC语言的关键字
//
//  Created by 周泽文 on 2017/6/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "TestClass.h"
#import "KeywordDefineClass.h"
@implementation TestClass
-(void)testMethod{
//   extern globalString = @"333";
    NSLog(@"%p %@",globalString,globalString);
    
    //globalString2 = @"222"; //globalString2是常量指针，不能修改
    NSLog(@"%p %@",globalString2,globalString2);
}
-(void)testMethod2{
    NSLog(@"%p %@",globalString2,globalString2);
}

@end
