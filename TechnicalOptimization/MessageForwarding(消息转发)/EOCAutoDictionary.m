//
//  EOCAutoDictionary.m
//  MessageForwarding
//
//  Created by 周泽文 on 2017/7/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "EOCAutoDictionary.h"
#import <objc/runtime.h>
@interface EOCAutoDictionary()
@property(nonatomic,strong)NSMutableDictionary *backingStore;
@end
@implementation EOCAutoDictionary
@dynamic string,number,date,opaqueObject;

-(instancetype)init{
    self = [super init];
    if (self) {
        _backingStore = [NSMutableDictionary new];
    }
    return self;
}

/**
  1 为什么会调用这个方法
   因为使用了@dynamic关键字修饰属性，被修饰的属性 编译器不会帮其生成setter getter方法
   其他类实例化 EOCAutoDictionary之后,调用实例属性的setter方法设值的时候 在实例中会找不到setter方法
   之后就会调用 resolveInstanceMethod方法，看EOCAutoDictionary类是否动态添加了setter方法
 
  2 class_addMethod的作用和参数的解释
  Class 指需要添加方法的类
  SEL 需要添加的方法名
  imp 用来实现 需要添加方法的函数
  types 一串字符  用来描述 imp的 返回值(v 代表void @代表对象) 要添加方法的类(@表示) 方法的名字(：表示) 方法的参数(@表示)
  https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 */
+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSString * selectorString = NSStringFromSelector(sel);
    if ([selectorString hasPrefix:@"set"]) {
        class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
    }else{
        class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
    }
    return YES;
}

id autoDictionaryGetter(id self,SEL _cmd){
    EOCAutoDictionary * typedSelf =(EOCAutoDictionary *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    NSString *key = NSStringFromSelector(_cmd);
    
    return [backingStore objectForKey:key];
}

void autoDictionarySetter(id self,SEL _cmd,id value){
    EOCAutoDictionary *typedSelf = (EOCAutoDictionary *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    
    /**
     1 方法名转换成字符串 比如setDate: 方法名     NSStringFromSelector(_cmd);
     2 拷贝一个可以修改的字符串                  [selectorString mutableCopy];
     3 去掉 :
     4 去掉 set
     5 Date 首字母改为小写
     6 将data 和 value 作为键值对保存在字典中
     */
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selectorString mutableCopy];
    [key deleteCharactersInRange:NSMakeRange(key.length - 1, 1)];
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    NSString * lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    
    if (value) {
        [backingStore setObject:value forKey:key];
    }else{
        [backingStore removeObjectForKey:key];
    }
}
@end
