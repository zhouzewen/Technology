//
//  TestWKWebView.m
//  PDFSaveToPhotosAlbum
//
//  Created by 周泽文 on 2017/8/3.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "TestWKWebView.h"
#import <WebKit/WebKit.h>

#define PDFUrl @"http://ei-test.51fapiao.cn:9080/FPFX/actions/347013a4332ca1a32892dee3e0d598c47701c0"
#define PDFUrl2 @"http://ei-test.51fapiao.cn:9080/FPFX/actions/f13955a658e7a2c208ae08daa055d82b7391e6"
@interface TestWKWebView ()
@property(nonatomic,strong)WKWebView * webView;
@end

@implementation TestWKWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSMutableURLRequest * mRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:PDFUrl2]];
    [_webView loadRequest:mRequest];
//    _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _webView.scrollView.contentOffset = CGPointZero;
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
