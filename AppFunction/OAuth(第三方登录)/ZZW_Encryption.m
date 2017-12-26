//
//  ZZW_Encryption.m
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/12.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ZZW_Encryption.h"
#import <CommonCrypto/CommonCryptor.h>// AES
#import <CommonCrypto/CommonDigest.h> //md5

#define gkey @"HL67LZ3M92P7DKWELY9X92LFNGD9TN77"
#define gIV @"R67FYRX8W57NYAFB"
@implementation ZZW_Encryption
// 对一个字符串中MD5加密
+(NSString *)md5:(NSString *)str{
    const char * cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), digest);
    
    NSMutableString *outPut = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPut appendFormat:@"%02x",digest[i]];
    }
    return outPut;
}

+(NSString *)AES128Decrypt:(NSString *)encryptText
{
    char keyPtr[kCCKeySizeAES256 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIV getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:0];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *resultStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        /**
         因为加密的时候为了得到32的整数倍位数，可能在明文的后面加上了若干个0x10
         所以解密的之后resultData数据后面会有 若干个 10101010 这些在转为字符串的时候就是 @"\x10"
         因此这些不是明文的内容，需要去掉，采用字符串的替换方法将其去掉，剩下的部分就是明文的内容了。
         */
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\x10" withString:@""];
        return resultStr;
    }
    free(buffer);
    return nil;
}
+(NSString *)AES128Encrypt:(NSString *)text{
    NSLog(@"%lu",text.length);
    
    /**
     key是32位长度的，所以使用kCCKeySizeAES256
     如果KEY是16位的则使用kCCKeySizeAES128
     */
    char keyPtr[kCCKeySizeAES256 + 1];
    memset(keyPtr,0,sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    /**
     IV是16位的
     */
    char ivPtr[kCCBlockSizeAES128 +1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIV getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    //在后面添加diff位0x10
    int diff = kCCKeySizeAES256 - (dataLength%kCCKeySizeAES256);
    NSUInteger newSize = 0;
    if (diff > 0) {
        newSize = dataLength + diff;
    }
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for (int i = 0; i < diff; i++) {
        dataPtr[i + dataLength] = 0x10;
    }
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCryted = 0;
    
    //0x0000 表示CBC
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCryted);
    if (cryptStatus == kCCSuccess) {
        NSData * resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCryted];
        NSData *base64Data = [resultData base64EncodedDataWithOptions:0];
        NSString * str = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        return  str;
    }
    free(buffer);
    return nil;
}


@end
