//
//  ZZW_Encryption.h
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/12.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZW_Encryption : NSObject

//FIXME: 还有解密的方法没有写，以及16位的key的加密方法,最好是传入key、iV 然后根据长度动态去判断使用16位还是32位
+(NSString *)AES128Encrypt:(NSString *)text;
+(NSString *)md5:(NSString *)str;
@end
