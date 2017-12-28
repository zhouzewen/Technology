//
//  ZZW_MD5.m
//  Encrypt&Decrypt(加密和解密)
//
//  Created by 周泽文 on 2017/12/27.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ZZW_MD5.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation ZZW_MD5

#pragma mark - 32位 小写
+(NSString *)MD5_32ByteLowerCaseWithPlainText:(NSString *)plainText{
    return [self MD5_32ByteWithPlainText:plainText isUpperCase:NO];
}

#pragma mark - 32位 大写
+(NSString *)MD5_32ByteUpperCaseWithPlainText:(NSString *)plainText{
    return [self MD5_32ByteWithPlainText:plainText isUpperCase:YES];
}
+(NSString *)MD5_32ByteWithPlainText:(NSString *)plainText isUpperCase:(BOOL)isUpperCase{
    //要进行UTF8的转码
    const char* input = [plainText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        if (isUpperCase == YES) {
            [digest appendFormat:@"%02X", result[i]];
        }else{
            [digest appendFormat:@"%02x", result[i]];
        }
    }
    return digest;
}

#pragma mark - 16位 大写
+(NSString *)MD5_16ByteUpperCaseWithPlainText:(NSString *)plainText{
    
    NSString *md5Str = [self MD5_32ByteUpperCaseWithPlainText:plainText];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


#pragma mark - 16位 小写
+(NSString *)MD5_16ByteLowerCaseWithPlainText:(NSString *)plainText{
    
    NSString *md5Str = [self MD5_32ByteLowerCaseWithPlainText:plainText];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

@end
