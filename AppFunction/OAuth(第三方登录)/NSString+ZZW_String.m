//
//  NSString+ZZW_String.m
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/12.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "NSString+ZZW_String.h"

@implementation NSString (ZZW_String)


/**
 因为url 字符串中 ?之后的 “=” 等符号需要转换 %3D,不然网络请求是发送不成功的
 但是苹果暂时没有提供这样的方法
 所以需要自己的写方法来实现
 
 参考资料
 https://stackoverflow.com/questions/8088473/how-do-i-url-encode-a-string
 //http://www.degraeve.com/reference/urlencoding.php // 特殊符号 与 url code 对照表
 */
- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end
