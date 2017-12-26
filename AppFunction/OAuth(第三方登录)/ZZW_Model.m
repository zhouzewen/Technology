//
//  ZZW_Model.m
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ZZW_Model.h"
#import "ZZW_Encryption.h"
#import "NSString+ZZW_String.h"
#define client_id_value @"flnetIOS"
#define client_id_key @"client_id"
#define redirect_uri_key @"redirect_uri"
#define redirect_uri_value @"http://interface.ite.newflnet.com/IHome/redirect"
#define code_key @"code"
#define grant_type_key @"grant_type"
#define grant_type_value @"authorization_code"
#define client_secret_key @"client_secret"
#define client_secret_value @"SdQXrQWkZzzsQ65T"

/**
 Oauth服務器地址：
 http://regs.ite.newflnet.com
 
 --------------------------------------------------------
 
 Oauth ID、密鑰與回調地址
 
 IOS：
 clientId: 'flnetIOS',
 clientSecret: 'SdQXrQWkZzzsQ65T',
 redirectUri: http://interface.ite.newflnet.com/IHome/redirect,
 ScqAw8y1/8INW/RjvUk3IHYAiDb8wRjAq8TahmKnEPdTuO2FY0r7B2bPGOwsYQL6QtUnDuJj0rdEiF5VO2B+EQ==
 
 --------------------------------------------------------
 AES加密用的key與iv：
 
 Aes Key
 HL67LZ3M92P7DKWELY9X92LFNGD9TN77
 
 Aes Iv
 R67FYRX8W57NYAFB
 
 Token驗證，如果過期了，請先用refresh token取得token，可參考以下作法。
 若refresh也過期了，才需重新取得code來換取token。
 Header中的Authorization值請參考備註。
 
 CURL：
 POST /oauth/token
 Header：
 Authorization: Basic VGVzdFVzZXI6UmNRN05GNnlhN3k0d001TnVPNDN2ZkNuMGdybXE1c2FFbUI5ZmNORWhhcz0=
 Content-Type: application/x-www-form-urlencoded
 參數：
 grant_type=refresh_token&refresh_token=3866bfe3ab73f71e9601907bc597271a7f61377c
 
 回傳值：
 錯誤範例：
 {
 "code": 400,
 "error": "invalid_grant",
 "error_description": "Invalid refresh token"
 }
 
 正常：
 {
 "token_type": "bearer",
 "access_token": "38b5cebe5dbff28b5e55bcb4524da2d9d7cb528d",
 "expires_in": 3600,
 "refresh_token": "23c0047203c3d4d69938ee9aec075fb80a35c26c"
 }
 
 備註：
 Authorization的值為Basic加空格，加上clientId:clientSeret的字串做base64。如：Basic base64(clientId:AES(clientSecret))
 範例：base64(TestUser:RcQ7NF6ya7y4wM5NuO43vfCn0grmq5saEmB9fcNEhas=)。
 TestUser是clientId，冒號後面為AES加密後的clientSecret
 
 */

@implementation ZZW_Model
+(NSURL *)getCodeUrl{
    return [NSURL URLWithString:@"http://regs.ite.newflnet.com/oauth/authorise"];
}
+(NSURL *)getTokenUrl{
    return [NSURL URLWithString:@"http://regs.ite.newflnet.com/oauth/token"];
}
+(NSString *)getTestUrlStr{
    /**
     5 旧的参数
     flnet正式环境的接口，这个暂时无法测试
     https://interface.flnet.com/IHome/GetAPPHomePage?lotType=1&version=1.1.40.20171214&systemVersion=9.3.4&phoneModel=iPhone&source=1&localcity=332
     flnet测试环境的接口
     http://interface.ite.newflnet.com/IHome/GetAPPHomePage?lotType=1&version=1.1.40.20171214&systemVersion=9.3.4&phoneModel=iPhone&source=1&localcity=332
     ? 之前的内容是url
     ? 之后的内容是所有的参数，这个部分的内容再转换为base64字符串的时候，不能含有=之类的字符
     & 用来分割不同的参数
     */
    return @"http://interface.ite.newflnet.com/IHome/GetAPPHomePage?lotType=1&version=1.1.40.20171214&systemVersion=9.3.4&phoneModel=iPhone&source=1&localcity=332";
}
+(NSDictionary *)getCodePostParameters{
    // 参数1 response_type  为固定值 ：code
    NSString *response_type = @"code";
    
    // 参数2 client_id  iOS设备为 ： flnetIOS
    
    // 参数3 redirect_uri  明文内容为 ： http://interface.ite.newflnet.com/IHome/redirect
    NSString * redirect_uri = redirect_uri_value;
    NSLog(@"redirect_uri : %@",redirect_uri);
    
    redirect_uri = [ZZW_Encryption AES128Encrypt:redirect_uri]; // 先用AES加密,然后转成base64字符串
    NSLog(@"redirect_uri encrypt : %@",redirect_uri);
    NSString *decrypt = [ZZW_Encryption AES128Decrypt:redirect_uri];
    NSLog(@"redirect_uri decrypt : %@",decrypt);
    redirect_uri = [redirect_uri urlencode]; //将字符串中的 =、/等符号转换为 URL Encoded Characters，这样发送网络请求的时候才能被服务器识别
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:response_type forKey:@"response_type"];
    [parameters setObject:client_id_value forKey:client_id_key];
    [parameters setObject:redirect_uri forKey:redirect_uri_key];
    
    return parameters.copy;
}
+(NSDictionary *)getTokenPostParameters{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //参数1 code  为getCode方法中获取到的code
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:code_key];
    [parameters setObject:code forKey:code_key];
    
    // 参数2 client_id  iOS设备为 ： flnetIOS
    [parameters setObject:client_id_value forKey:client_id_key];
    
    // 参数3 client_secret  明文为 ： SdQXrQWkZzzsQ65T
    NSString *client_secret = client_secret_value;
    client_secret = [ZZW_Encryption AES128Encrypt:client_secret]; // 先用AES加密,然后转成base64字符串
    client_secret = [client_secret urlencode]; //将字符串中的 =、/等符号转换为 URL Encoded Characters，这样发送网络请求的时候才能被服务器识别
    [parameters setObject:client_secret forKey:client_secret_key];
    
    // 参数4 grant_type  固定值 ： authorization_code
    [parameters setObject:grant_type_value forKey:grant_type_key];
    
    
    
    
    
    
    
    return parameters.copy;
}

+(NSDictionary *)getExtraParameters{
    // 参数1 tk  为getToken方法中获取到的access_token
    NSString * tk = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    
    //参数2 partnerid  固定值 ： a47b86b0d408de3f
    NSString * partnerid = @"a47b86b0d408de3f";
    
    //参数3 timestamp  为中国时区的时间戳，具体指1970年到中国时区当前时间的毫秒数
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;// UTC时间，中国时间是UTC时间+8小时
    NSTimeInterval chinaTime = time + 8*3600;
    NSString * timestamp = [NSString stringWithFormat:@"%.0f",chinaTime];
    
    // 参数4 noncestr  随机字符串，产生的方式不限，这里使用最简单的方式
    NSString * noncestr = [NSString stringWithFormat:@"%u",arc4random()] ;//随机函数生成的数字转换为字符串
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:tk forKey:@"tk"];
    [parameters setObject:partnerid forKey:@"partnerid"];
    [parameters setObject:timestamp forKey:@"timestamp"];
    [parameters setObject:noncestr forKey:@"noncestr"];
    
    return parameters.copy;
}
+(NSDictionary *)getParamtersDicFromParamtersStr:(NSString *)paramStr{
    NSArray *arr = [paramStr componentsSeparatedByString:@"&"];// 根据 & 切割字符串 组成数组
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];// 用字典来保存所有的参数名和参数值
    for (NSString *str in arr) {
        NSString *key = [str componentsSeparatedByString:@"="][0];
        NSString *value = [str componentsSeparatedByString:@"="][1];
        [dic setValue:value forKey:key];
    }
    return dic.copy;
}
+(NSDictionary *)getSignDicWithParameter:(NSString *)parameter{
    NSString * secert = @"ba3f2adea47b86b0d408de3f7e4d922c";
    NSString *inputStr = [NSString stringWithFormat:@"%@%@",parameter,secert];//将secert接到第一步得到的字符串后面
    NSString * sign = [ZZW_Encryption md5:inputStr];//对这个字符串做md5加密
    return @{@"sign":sign};
}

+(NSString *)getBase64StrWithParameter:(NSString *)parameter{
    NSData *data = [parameter dataUsingEncoding:NSUTF8StringEncoding]; //先将字符串转为NSData类型的数据
    NSString *base64Str = [data base64EncodedStringWithOptions:0]; // 然后再将NSData类型的数据转换为base64字符串
    return base64Str;
}
+(NSString *)getUrlencodeStrWithParameter:(NSString *)param{
    return [param urlencode];
}
@end
