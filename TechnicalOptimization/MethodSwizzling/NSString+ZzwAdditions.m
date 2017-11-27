//
//  NSString+ZzwAdditions.m
//  MethodSwizzling
//
//  Created by 周泽文 on 2017/7/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "NSString+ZzwAdditions.h"

@implementation NSString (ZzwAdditions)
-(NSString*)Zzw_myLowercaseString{
    NSString * lowercase = [self Zzw_myLowercaseString];
    NSLog(@"%@ => %@",self,lowercase);
    return lowercase;
}
@end
