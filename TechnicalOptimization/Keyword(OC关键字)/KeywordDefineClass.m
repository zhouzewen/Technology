//
//  KeywordDefineClass.m
//  OC语言的关键字
//
//  Created by 周泽文 on 2017/6/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "KeywordDefineClass.h"

NSString *  globalString = @"global string";
NSString * const globalString2 = @"global stirng2";

@implementation KeywordDefineClass
-(void)changeKeywordValue{
//    &globalString2 = &@"test";
}
-(void)testConstKeyword{
    int a = 15;
    int b = 20;
    const int * p = &a; // 指针指向的值是常量，不能通过寻址的方式去修改
    NSLog(@"%p %d",p,*p);
    
    a = 30;
    NSLog(@"%p %d",p,*p);
   // *p = 40; //不能通过这种寻址的方式去修改 变量a的值
    
    p = &b;
    NSLog(@"%p %d",p,*p);
    
    
    int * const m = &b; // 指针是常亮
    NSLog(@"%p %d",m,*m);
//    m = &a;// 不能修改指针
    *m = 30;
    NSLog(@"%p %d",m,*m);
    
    
}

-(void)testExternKeyword{

}
@end
