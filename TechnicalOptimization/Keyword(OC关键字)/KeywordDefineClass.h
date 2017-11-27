//
//  KeywordDefineClass.h
//  OC语言的关键字
//
//  Created by 周泽文 on 2017/6/28.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 声明一个全局变量的值，可使用extern关键字
 但是无法立刻初始化， extern NSString * globalString=@"test" 这样是不行的
 一般会在.m文件中定义这个变量的值
 其他的所有文件都可以使用这个变量，修改这个变量 每次修改都会新生成一份内存
 */

extern NSString * globalString;
extern NSString * const globalString2;
/**
 static 关键字可以用来延长变量的声明周期，使之和程序的生命周期相同
 其内存只会初始化一次
 */
static NSString * string = @"123";
@interface KeywordDefineClass : NSObject
-(void)testConstKeyword;
@end
