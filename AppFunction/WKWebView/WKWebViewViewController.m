//
//  WKWebViewViewController.m
//  WKWebView
//
//  Created by 周泽文 on 2018/1/6.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "WKWebViewViewController.h"
#import <WebKit/WebKit.h>
@interface WKWebViewViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation WKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //网页内容宽度适配  测试没有效果
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//
//    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//
//    [wkUController addUserScript:wkUScript];
//
//    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//
//    wkWebConfig.userContentController = wkUController;
//
//    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    
    //20559 21113
    NSString *urlStr = @"https://interface.flnet.com/Product/AppProductDetails?id=21113";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    // Do any additional setup after loading the view.
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    // 自签名的服务器证书
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}


@end
