//
//  ViewController.m
//  WKWebView
//
//  Created by 周泽文 on 2018/1/5.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewViewController.h"
@interface ViewController ()<UIWebViewDelegate,NSURLConnectionDelegate,NSURLSessionDelegate>{
    BOOL _authenticated;
    NSURLConnection *_urlConnection;
    NSURLSession *_session;
    NSURLSessionTask *_task;
    NSURLRequest *_request;
}
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 200, 50)];
    [button setTitle:@"testWKWebView" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testWKWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(100, 200, 200, 50)];
    [button2 setTitle:@"testUIWebView" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(testUIWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}
#pragma mark - Selector
-(void)testWKWebView{
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self];
    WKWebViewViewController *vc = [[WKWebViewViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
//    [navi pushViewController:vc animated:YES];
    
}
-(void)testUIWebView{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    //20559 21113
    NSString *urlStr = @"https://interface.flnet.com/Product/AppProductDetails?id=20559";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    //1
    if (!_authenticated) {
        _authenticated = NO;
        _request = request;
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [_urlConnection start];
        
//        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//        _task = [_session dataTaskWithRequest:request];
//        [_task resume];

        return NO;
    }
    return YES;

}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    NSLog(@"error.userInfo : %@",error.userInfo);
}
#pragma mark - NSURLSessionDelegate
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
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [_webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [dataTask cancel];
}
#pragma mark - NURLConnection delegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [_webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}




@end
