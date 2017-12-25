//
//  ZZW_HttpHelper.m
//  WineValidation
//
//  Created by 周泽文 on 2017/7/14.
//  Copyright © 2017年 Fox. All rights reserved.
//

#import "ZZW_HttpHelper.h"

@interface ZZW_HttpHelper()<NSURLSessionDataDelegate>
@property(nonatomic,strong)NSURLSession * session;
@property(nonatomic,strong)NSMutableData * infoData;
@end

@implementation ZZW_HttpHelper
#pragma mark - LifeCycle
-(instancetype)init{
    self = [super init];
    if (self) {
        _infoData = [NSMutableData data];
    }
    return self;
}

#pragma mark - Public
-(void)postRequestWithUrl:(NSURL *)url andHttpBodyString:(NSString *)httpBody{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask * task = [_session dataTaskWithRequest:request];
    [task resume];
}

// 发送get 请求
-(void)getRequestWith:(NSString *)str{
    // 快捷方式获得session对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:str];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLSessionTask * task = [session dataTaskWithRequest:request];
    // 启动任务
    [task resume];
    
}

/**
 1 传递一个包含了url以及所有参数的字典
 2 取出url 作为请求的url
 3 取出所有参数 并用&拼接 组成参数字典
 */
-(void)postRequestToServerWithDic:(NSDictionary *)dic{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:dic[@"url"]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    request.HTTPMethod = @"POST";
    __block NSMutableString * body = nil;
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        if (![key isEqualToString:@"url"]) {
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
            [body appendString:[NSString stringWithFormat:@"%@&",str]];
        }
    }];
    NSString *httpBody = [body copy];
    request.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask * task = [_session dataTaskWithRequest:request];
    [task resume];
}
/**
    将url 和 参数分开
*/
-(void)postRequestToServerWithUrl:(NSURL *)url parameters:(NSDictionary *)parameters{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    request.HTTPMethod = @"POST";
    __block NSMutableString * body = nil;
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
        [body appendString:[NSString stringWithFormat:@"%@&",str]];
    }];
    NSString *httpBody = [body copy];
    request.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];

    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask * task = [_session dataTaskWithRequest:request];
    [task resume];
}




#pragma mark -NSURLSessionDelegate
// 发送https请求，需要先验证服务器的证书，并保存证书
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    // 判断证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"是服务器信任的整数");
        // 生成证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 保存证书
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [self.infoData appendData:data];
}

-(void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    NSDictionary *dic = nil;
    if (!error) {
         dic = [NSJSONSerialization JSONObjectWithData:self.infoData options:NSJSONReadingAllowFragments error:nil];//将返回的json数据转成字典
    } else {
        dic = @{@"error":[NSNumber numberWithInteger:error.code]};
    }
    if (_delegate &&[_delegate respondsToSelector:@selector(httpHelper:responseInfo:)]) {
        [_delegate httpHelper:self responseInfo:dic];
    }
    [_session invalidateAndCancel];
}
@end
