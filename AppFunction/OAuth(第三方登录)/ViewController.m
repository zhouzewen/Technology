//
//  ViewController.m
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/11.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//


#import "ViewController.h"
#import "ZZW_HttpHelper.h"
#import "ZZW_Tool.h"
#import "ZZW_Model.h"
@interface ViewController ()<ZZW_HttpHelperDelegate>{
    NSString *_code;
    NSString *_access_token;
    ZZW_HttpHelper *_helper;
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

#pragma mark - ZZW_HttpHelperDelegate
-(void)httpHelper:(ZZW_HttpHelper *)helper responseInfo:(NSDictionary *)infoDic{
    static int  count = 0;
    NSLog(@"%d dic : %@",count,infoDic);
    if (count == 0) {
        // 1 保存获取到的code,并请求token
        if (![infoDic[@"data"] isEqualToString:@""]){
            _code = infoDic[@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:infoDic[@"data"] forKey:@"code"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self getToken];
        }
        
    }else if (count == 1) {
        // 2 保存获取的token，根据token生成新的接口请求数据
        if (![infoDic[@"access_token"] isEqualToString:@""]){
            _access_token = infoDic[@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:infoDic[@"access_token"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self getNewInterfaceAndSendGetRequest];
        }
    }
    count++;
}

#pragma mark - Private
-(void)testHttps{
    NSString *urlStr = @"https://interface.flnet.com/IHome/GetAPPHomePage?bG90VHlwZT0yJnZlcnNpb249MS4xLjM5LjEmc3lzdGVtVmVyc2lvbj0xMS4yJnBob25lTW9kZWw9aVBob25lJnNvdXJjZT0xJmxvY2FsY2l0eT0zMzI=";
    for (NSInteger i = 0; i < 10; i++) {
        ZZW_HttpHelper *helper = [[ZZW_HttpHelper alloc] init];
        helper.delegate = self;
        [helper getRequestWith:urlStr];
    }
}

// 目标 向oauth 服务器获取code
-(void)getCode{
    NSURL * url = [ZZW_Model getCodeUrl];// 接口url
    NSDictionary *parameters = [ZZW_Model getCodePostParameters];// 获取参数字典
    NSString *httpBody = [ZZW_Tool getHttpBodyFromParameters:parameters];
    [self sendPostRequestWithUrl:url httpBody:httpBody];// 发送post请求，获取code
}

// 目标 向oauth 服务器获取token
-(void)getToken{
    NSURL * url = [ZZW_Model getTokenUrl];// 接口url
    NSDictionary *parameters = [ZZW_Model getTokenPostParameters];// 获取参数字典
    NSString *httpBody = [ZZW_Tool getHttpBodyFromParameters:parameters];
    [self sendPostRequestWithUrl:url httpBody:httpBody];
    
}
-(void)sendPostRequestWithUrl:(NSURL *)url httpBody:(NSString *)httpBody{
    // 用同一个_help 会报错Error Domain=NSURLErrorDomain Code=-999
    ZZW_HttpHelper *helper = [[ZZW_HttpHelper alloc] init];
    helper.delegate = self;
    [helper postRequestWithUrl:url andHttpBodyString:httpBody];// 发送post请求，获取code
}

// 目标 给旧的接口添加参数，组成新的接口 请求数据
-(void)getNewInterfaceAndSendGetRequest{
    NSString *interfaceStr = [ZZW_Model getTestUrlStr];
    
    NSString *interfaceUrl = [interfaceStr componentsSeparatedByString:@"?"][0]; // 获取接口地址
    
    NSString * oldParams = [interfaceStr componentsSeparatedByString:@"?"][1];//拿到接口中 ? 之后的参数字符串
    NSDictionary *oldParamsDic = [ZZW_Model getParamtersDicFromParamtersStr:oldParams];
    
    NSDictionary *extraParams = [ZZW_Model getExtraParameters];// 获取 额外的参数
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];// 用字典来保存所有的参数名和参数值
    [oldParamsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dic setObject:obj forKey:key];
    }];
    
    [extraParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dic setValue:obj forKey:key];
    }];
    
     //(1)    將tk、商戶號、時間戳、隨機字串、舊有的參數將參數名稱排序後，組成『…&noncestr=xxx&partnered=xxx&timestamp=xxx&tk=xxx&…』字串。
    NSArray *sortArr = [ZZW_Tool ascendeSortArray:dic.allKeys];
    NSString *paramStr = [ZZW_Tool combinedStringSortedArr:sortArr andParameters:dic.copy];
    
    /**
     (2)    將(1)產生的字串串接interface接口Secert：ba3f2adea47b86b0d408de3f7e4d922c
     後使用UTF-8編碼的MD5做簽名
     这个加密之后的字符串也会做为一个参数加入到接口中，参数的名为sign
     */
    NSDictionary *signDic = [ZZW_Model getSignDicWithParameter:paramStr];
    [signDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dic setObject:obj forKey:key];
    }];

     //(3)    將tk、商戶號、時間戳、隨機字串、舊有的參數再加上(2)產生的簽名將參數名稱排序後，組成『…&noncestr=xxx&partnered=xxx&sign=xxx&timestamp=xxx&tk=xxx&…』字串。
    NSArray *sortArr2 = [ZZW_Tool ascendeSortArray:dic.allKeys];
    NSString *paramStr2 = [ZZW_Tool combinedStringSortedArr:sortArr2 andParameters:dic.copy];
    
    NSString *base64Str = [ZZW_Model getBase64StrWithParameter:paramStr2];// (4)    將(3)產生的字串Base64。
    base64Str = [ZZW_Model getUrlencodeStrWithParameter:base64Str];// 将字符串中的 =、/等符号转换为 URL Encoded Characters，这样发送网络请求的时候才能被服务器识别
    
    NSString *finalStr = [NSString stringWithFormat:@"%@?%@",interfaceUrl,base64Str];//(5)    調用接口『接口地址 + ? + (4)產生的字串』
    ZZW_HttpHelper * helper = [[ZZW_HttpHelper alloc] init];
    helper.delegate = self;
    [helper getRequestWith:finalStr];// 发送get请求
}

@end
