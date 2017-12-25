//
//  ZZW_Tool.m
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ZZW_Tool.h"

@implementation ZZW_Tool
// 将一个数组升序排列
+(NSArray *)ascendeSortArray:(NSArray *)arr{
    NSArray *sortArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return sortArr;
}
+(NSString *)combinedStringSortedArr:(NSArray *)sortArr andParameters:(NSDictionary *)parameters{
    NSMutableArray *keyValueArr = [NSMutableArray array];
    for (NSString *key in sortArr) {
        NSString * str = [NSString stringWithFormat:@"%@=%@",key,parameters[key]];
        [keyValueArr addObject:str];
    }
    //将上面得到的数组所有元素 升序串接起来得到参数字符串
    NSMutableString *paramStr = [NSMutableString string];
    for (NSInteger i = 0; i < keyValueArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@&",keyValueArr[i]];
        if (i == keyValueArr.count - 1) {
            str = keyValueArr[i];
        }
        [paramStr appendString:str];
    }
    return [NSString stringWithFormat:@"%@",paramStr];
}
+(NSString *)getHttpBodyFromParameters:(NSDictionary *)parameters{
    NSMutableArray *keyValueArr = [NSMutableArray array];
    for (NSString *key in parameters.allKeys) {
        NSString * str = [NSString stringWithFormat:@"%@=%@",key,parameters[key]];
        [keyValueArr addObject:str];
    }
    //将上面得到的数组所有元素 升序串接起来得到参数字符串
    NSMutableString *paramStr = [NSMutableString string];
    for (NSInteger i = 0; i < keyValueArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@&",keyValueArr[i]];
        if (i == keyValueArr.count - 1) {
            str = keyValueArr[i];
        }
        [paramStr appendString:str];
    }
    return [NSString stringWithFormat:@"%@",paramStr];
}
@end
