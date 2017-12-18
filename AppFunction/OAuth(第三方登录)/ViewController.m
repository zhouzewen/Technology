//
//  ViewController.m
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/11.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

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
#import "ViewController.h"
#import "HttpHelper.h"
#import "NSString+ZZW_String.h"
#import "DES3Util.h"
#import <CommonCrypto/CommonDigest.h>
@interface ViewController ()<HttpHelperDelegate>{
    NSString *_code;
    NSString *_access_token;
    HttpHelper *_helper;
}

@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
//    [self testHttps];
    [self getCode];
    
}

#pragma mark - HttpHelperDelegate
-(void)serverResponseInfo:(NSDictionary *)dic{
    static int  count = 0;
    NSLog(@"%d dic : %@",count,dic);
    if (count == 0) {
        // 1 保存获取到的code,并请求token
        if (![dic[@"data"] isEqualToString:@""]) _code = dic[@"data"];
        [self getToken];
    }
    if (count == 1) {
        // 2 保存获取的token，根据token生成新的接口请求数据
        _access_token = dic[@"access_token"];
        [self getNewInterfaceAndSendGetRequest];
    }
    count++;
}

#pragma mark - Private
-(void)testHttps{
    NSString *urlStr = @"https://interface.flnet.com/IHome/GetAPPHomePage?bG90VHlwZT0yJnZlcnNpb249MS4xLjM5LjEmc3lzdGVtVmVyc2lvbj0xMS4yJnBob25lTW9kZWw9aVBob25lJnNvdXJjZT0xJmxvY2FsY2l0eT0zMzI=";
    for (NSInteger i = 0; i < 10; i++) {
        HttpHelper *helper = [[HttpHelper alloc] init];
        helper.delegate = self;
        [helper getRequestWith:urlStr];
    }
}
-(void)getCode{
    // 目标 向oauth 服务器获取code
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    helper.delegate = self;
    // 接口url
    NSURL * url = [NSURL URLWithString:@"http://regs.ite.newflnet.com/oauth/authorise"];
    // 参数1 response_type  为固定值 ：code
    NSString *response_type = @"code";
    
    // 参数2 client_id  iOS设备为 ： flnetIOS
    NSString *client_id = @"flnetIOS";
    
    // 参数3 redirect_uri  明文内容为 ： http://interface.ite.newflnet.com/IHome/redirect
    NSString * redirect_uri = @"http://interface.ite.newflnet.com/IHome/redirect";
    redirect_uri = [DES3Util AES128Encrypt:redirect_uri]; // 先用AES加密,然后转成base64字符串
    redirect_uri = [redirect_uri urlencode]; //将字符串中的 =、/等符号转换为 URL Encoded Characters，这样发送网络请求的时候才能被服务器识别
    
    // 发送post请求，获取code
    [helper postRequestWithUrl:url response_type:response_type client_id:client_id redirect_uri:redirect_uri];
}
-(void)getToken{
    // 目标 向oauth 服务器获取token
    
    // 接口url
    NSURL * url = [NSURL URLWithString:@"http://regs.ite.newflnet.com/oauth/token"];
    
    //参数1 code  为getCode方法中获取到的code
    NSString *code = _code;
    
    // 参数2 client_id  iOS设备为 ： flnetIOS
    NSString *client_id = @"flnetIOS";
    
    // 参数3 client_secret  明文为 ： SdQXrQWkZzzsQ65T
    NSString *client_secret = @"SdQXrQWkZzzsQ65T";
    client_secret = [DES3Util AES128Encrypt:client_secret]; // 先用AES加密,然后转成base64字符串
    client_secret = [client_secret urlencode]; //将字符串中的 =、/等符号转换为 URL Encoded Characters，这样发送网络请求的时候才能被服务器识别
    
    // 参数4 grant_type  固定值 ： authorization_code
    NSString *grant_type = @"authorization_code";
    
    HttpHelper * _helper2 = [[HttpHelper alloc] init]; // 用同一个_help 会报错Error Domain=NSURLErrorDomain Code=-999
    _helper2.delegate = self;
    [_helper2 postRequestWithUrl:url code:code client_id:client_id client_secret:client_secret grant_type:grant_type];
}
-(void)getNewInterfaceAndSendGetRequest{
    // 目标 给旧的接口添加参数，组成新的接口 请求数据
    
    // 参数1 tk  为getToken方法中获取到的access_token
    NSString * tk = _access_token;
    
    //参数2 partnerid  固定值 ： a47b86b0d408de3f
    NSString * partnerid = @"a47b86b0d408de3f";
    
    //参数3 timestamp  为中国时区的时间戳，具体指1970年到中国时区当前时间的毫秒数
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;// UTC时间，中国时间是UTC时间+8小时
    NSTimeInterval chinaTime = time + 8*3600;
    NSString * timestamp = [NSString stringWithFormat:@"%.0f",chinaTime];
    
    // 参数4 noncestr  随机字符串，产生的方式不限，这里使用最简单的方式
    NSString * noncestr = [NSString stringWithFormat:@"%u",arc4random()] ;//随机函数生成的数字转换为字符串
    
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
    
    NSString *interfaceStr = @"http://interface.ite.newflnet.com/IHome/GetAPPHomePage?lotType=1&version=1.1.40.20171214&systemVersion=9.3.4&phoneModel=iPhone&source=1&localcity=332";
    NSString * oldParams = [interfaceStr componentsSeparatedByString:@"?"][1];//拿到接口中 ? 之后的字符串
    NSArray * arr = [oldParams componentsSeparatedByString:@"&"];// 根据 & 切割字符串 组成数组
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];// 用字典来保存所有的参数名和参数值
    for (NSString *str in arr) {
        NSString *key = [str componentsSeparatedByString:@"="][0];
        NSString *value = [str componentsSeparatedByString:@"="][1];
        [dic setValue:value forKey:key];
    }
    [dic setValue:tk forKey:@"tk"];
    [dic setValue:partnerid forKey:@"partnerid"];
    [dic setValue:timestamp forKey:@"timestamp"];
    [dic setValue:noncestr forKey:@"noncestr"];
    
    /**
     第一步
     (1)    將tk、商戶號、時間戳、隨機字串、舊有的參數將參數名稱排序後，
     組成『…&noncestr=xxx&partnered=xxx&timestamp=xxx&tk=xxx&…』字串。
     */
    NSString *paramStr = [self getSortStringWithDic:[dic copy]];
    
    
    /**
     第二步
     (2)    將(1)產生的字串串接interface接口Secert：ba3f2adea47b86b0d408de3f7e4d922c
     後使用UTF-8編碼的MD5做簽名
     这个加密之后的字符串也会做为一个参数加入到接口中，参数的名为sign
     */
    //
    NSString * secert = @"ba3f2adea47b86b0d408de3f7e4d922c";
    NSString *inputStr = [NSString stringWithFormat:@"%@%@",paramStr,secert];//将secert接到第一步得到的字符串后面
    NSString * sign = [self md5:inputStr];//对这个字符串做md5加密
    [dic setValue:sign forKey:@"sign"];//添加到参数的字典中
    
    /**
     第三步
     (3)    將tk、商戶號、時間戳、隨機字串、舊有的參數再加上(2)產生的簽名將參數名稱排序後，
     組成『…&noncestr=xxx&partnered=xxx&sign=xxx&timestamp=xxx&tk=xxx&…』字串。
     */
    NSString *paramStr2 = [self getSortStringWithDic:[dic copy]];
    
    /**
     第四步
     (4)    將(3)產生的字串Base64。
     */
    NSData *data = [paramStr2 dataUsingEncoding:NSUTF8StringEncoding]; //先将字符串转为NSData类型的数据
    NSString *base64Str = [data base64EncodedStringWithOptions:0]; // 然后再将NSData类型的数据转换为base64字符串
    base64Str = [base64Str urlencode]; // 将字符串中的 =、/等符号转换为 URL Encoded Characters，这样发送网络请求的时候才能被服务器识别
    
    
    /**
     第五步
     (5)    調用接口『接口地址 + ? + (4)產生的字串』
     */
    NSString *interfaceUrl = [interfaceStr componentsSeparatedByString:@"?"][0]; // 获取接口地址
    NSString *finalStr = [NSString stringWithFormat:@"%@?%@",interfaceUrl,base64Str];
    HttpHelper * helper = [[HttpHelper alloc] init];
    helper.delegate = self;
    [helper getRequestWith:finalStr];// 发送get请求
}

// 升序排列字典的key，并组成接口的字符串
-(NSString *)getSortStringWithDic:(NSDictionary *)dic{
    //对字典中所有的key 做升序排列
    NSArray *keyArr = dic.allKeys;
    NSArray *sortArr = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //按照上面的升序 将字典中的key value 用= 连接组成字符串 保存到一个数组中
    NSMutableArray *keyValueArr = [NSMutableArray array];
    for (NSString *key in sortArr) {
        NSString * str = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
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

// 对一个字符串中MD5加密
-(NSString *)md5:(NSString *)str{
    const char * cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), digest);
    
    NSMutableString *outPut = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPut appendFormat:@"%02x",digest[i]];
    }
    return outPut;
}



@end
