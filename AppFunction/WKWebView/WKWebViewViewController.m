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
    /**
     1 wkwebView的使用
     https://www.jianshu.com/p/556c988e2707
     2 https
     https://www.jianshu.com/p/9513d101e582
     3 网页内容宽度适配  测试没有效果
     //https://www.jianshu.com/p/cbf714b05d59
     //https://www.jianshu.com/p/255fdb8f60d3
     
     4 WKWebView强大的新特性
     http://www.cocoachina.com/ios/20180111/21818.html
     
     */
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
//    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [[[_webView subviews] lastObject] setZoomScale:0.4];
    
    
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
