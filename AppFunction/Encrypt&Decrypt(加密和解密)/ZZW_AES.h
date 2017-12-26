//
//  ZZW_AES.h
//  Encrypt&Decrypt(加密和解密)
//
//  Created by 周泽文 on 2017/12/26.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZW_AES : NSObject

/**
 AES加密解密两个方法会自动根据key的长度
 判断使用128还是256的加密解密keySize
 */
+(NSString *)AES_EncryptText:(NSString *)plainText WithKey:(NSString *)key andIV:(NSString *)iv;
+(NSString *)AES_DecryptText:(NSString *)encryptText WithKey:(NSString *)key andIV:(NSString *)iv;
@end
