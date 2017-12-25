//
//  ZZW_Model.h
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZW_Model : NSObject
+(NSURL *)getCodeUrl;
+(NSURL *)getTokenUrl;
+(NSString *)getTestUrlStr;
+(NSDictionary *)getCodePostParameters;
+(NSDictionary *)getTokenPostParameters;
+(NSDictionary *)getExtraParameters;
+(NSDictionary *)getParamtersDicFromParamtersStr:(NSString *)paramStr;
+(NSDictionary *)getSignDicWithParameter:(NSString *)parameter;
+(NSString *)getBase64StrWithParameter:(NSString *)parameter;
+(NSString *)getUrlencodeStrWithParameter:(NSString *)param;
@end
