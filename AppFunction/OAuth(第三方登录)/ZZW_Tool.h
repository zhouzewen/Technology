//
//  ZZW_Tool.h
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZW_Tool : NSObject
+(NSArray *)ascendeSortArray:(NSArray *)arr;
+(NSString *)combinedStringSortedArr:(NSArray *)sortArr andParameters:(NSDictionary *)parameters;
+(NSString *)getHttpBodyFromParameters:(NSDictionary *)parameters;
@end
