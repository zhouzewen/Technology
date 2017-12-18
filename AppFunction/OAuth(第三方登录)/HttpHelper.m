//
//  HttpHelper.m
//  WineValidation
//
//  Created by 周泽文 on 2017/7/14.
//  Copyright © 2017年 Fox. All rights reserved.
//

#import "HttpHelper.h"
#import <UIKit/UIDevice.h>


static NSString * const AES_Key = @"HL67LZ3M92P7DKWELY9X92LFNGD9TN77";
static NSString * const AES_IV = @"R67FYRX8W57NYAFB";
@interface HttpHelper()<NSURLSessionDataDelegate>
@property(nonatomic,strong)NSURLSession * session;
@property(nonatomic,strong)NSMutableData * infoData;
@end
@implementation HttpHelper
#pragma mark - LifeCycle
-(instancetype)init{
    self = [super init];
    if (self) {
        _infoData = [[NSMutableData alloc] init];
    }
    return self;
}

#pragma mark - Public
-(void)postRequestWithUrl:(NSURL*)url
            response_type:(NSString *)response_type
                client_id:(NSString *)client_id
             redirect_uri:(NSString *)redirect_uri{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    request.HTTPMethod = @"POST";
    
    NSString *httpBody = [NSString stringWithFormat:@"response_type=%@&client_id=%@&redirect_uri=%@",response_type,client_id,redirect_uri];
    
    request.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask * task = [_session dataTaskWithRequest:request];
    [task resume];
    
}
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
-(void)postRequestWithUrl:(NSURL*)url
                     code:(NSString *)code
                client_id:(NSString *)client_id
            client_secret:(NSString *)client_secret
               grant_type:(NSString *)grant_type{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    request.HTTPMethod = @"POST";
    
    NSString *httpBody = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&grant_type=%@",code,client_id,client_secret,grant_type];
    
    request.HTTPBody = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask * task = [_session dataTaskWithRequest:request];
    [task resume];
}
-(void)postRequestWithUrl:(NSURL *)url andParameters:(NSString *)str{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask * task = [_session dataTaskWithRequest:request];
    [task resume];
}

-(void)postRequestWithUrl:(NSURL *)url
                       tk:(NSString *)tk
                partnerid:(NSString *)partnerid
                timestamp:(NSString *)timestamp
                 noncestr:(NSString *)noncestr{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    request.HTTPMethod = @"POST";
    
    NSString *httpBody = [NSString stringWithFormat:@"tk=%@&partnerid=%@&timestamp=%@&noncestr=%@",tk,partnerid,timestamp,noncestr];
    
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
    if (!error) {
        // 调用工具方法 处理data 返回需要的字典
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:self.infoData options:NSJSONReadingAllowFragments error:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(serverResponseInfo:)]) {
            [self.delegate serverResponseInfo:dic];
        }
    } else {
        NSLog(@"%@",error);
        NSDictionary * dic = @{@"error":[NSNumber numberWithInteger:error.code]};
        if (self.delegate && [self.delegate respondsToSelector:@selector(serverResponseInfo:)]) {
            [self.delegate serverResponseInfo:dic];
        }
    }
    [_session invalidateAndCancel];
}
@end
