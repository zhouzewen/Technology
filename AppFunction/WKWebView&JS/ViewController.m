//
//  ViewController.m
//  WKWebView&JS
//
//  Created by 周泽文 on 2018/1/20.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#define kBridgeName           @"external"
#define CIVETVERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong) UIProgressView *myProgressView;
@end
static void *WkwebBrowserContext = &WkwebBrowserContext;
@implementation ViewController

#pragma mark - LifeCycle
//+ (void)initialize
//{
//    NSString *userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; U; CPU OS 4_2_1 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/4.0 Mobile/8C148 Safari/528.16/iCivet iOS ver %@ JS ver1.0 yyh",CIVETVERSION];
//    NSDictionary *userAgentDictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:userAgentDictionary];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"userAgentDictionary：：：%@",userAgent);
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:@"test123" forKey:@"123"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    NSLog(@"DocumentPath: %@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]);
    NSLog(@"Bundle : %@",[NSBundle mainBundle].bundlePath);
//    vc.browerurl = @"http://localhost/index2.html";
//    vc.browerurl = @"http://192.168.2.1/index2.html";
    // Do any additional setup after loading the view, typically from a nib.
    //自动适应尺寸
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    wkWebConfig.selectionGranularity = WKSelectionGranularityCharacter;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkWebConfig];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [[[_webView subviews] lastObject] setZoomScale:0.4];
    _webView.backgroundColor = [UIColor cyanColor];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    //kvo 添加进度监控
    [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
    _webView.autoresizesSubviews = YES; //自动调整大小
    _webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    _webView.userInteractionEnabled= YES;
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *urlStr = @"http://icivetapps.foxconn.com.tw/civetpays/yyh2018s/eticket/login.html";
//    NSString *urlStr = @"http://192.168.2.1/index2.html";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
-(void)dealloc{
    [[NSUserDefaults standardUserDefaults] setObject:@"test1234" forKey:@"1234"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigationDelegate
//页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    //开始加载的时候，让加载进度条显示
    self.myProgressView.hidden = NO;
}

// 页面加载完毕时调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [webView evaluateJavaScript:[NSString stringWithFormat:@"typeof window.%@ == 'object'", kBridgeName] completionHandler:^(NSString *str, NSError * _Nullable error) {
        // if (![str isEqualToString:@"true"]) {
        unsigned int methodCount = 0;
        Method *methods = class_copyMethodList([self class], &methodCount);
        NSMutableString *methodList = [NSMutableString string];
        for (int i=0; i<methodCount; i++) {
            NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
            [methodList appendString:@"\""];
            [methodList appendString:[methodName stringByReplacingOccurrencesOfString:@":" withString:@""]];
            [methodList appendString:@"\","];
        }
        free(methods);
        if (methodList.length>0) {
            [methodList deleteCharactersInRange:NSMakeRange(methodList.length-1, 1)];
        }
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *filePath = [bundle pathForResource:@"WebViewJsBridge" ofType:@"js"];
        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [webView evaluateJavaScript:[NSString stringWithFormat:js, methodList] completionHandler:nil];
        //   }
    }];
    
//    theBool = true;
//    if(self.isMBGrocess==1)
//    {
//        if([self.view viewWithTag:1005])
//        {
//            self.isMBGrocess=0;
//        }
//    }
//    if(webView.canGoBack && !self.isIndex && !self.isLogin){
//        [self leftBarItemsHidden:NO];
//    }
//    else{
//        [self leftBarItemsHidden:YES];
//    }
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

//请求之前，决定是否要跳转:用户点击网页上的链接，需要打开新页面时，将先调用这个方法。
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL *url = [navigationAction.request URL];
    NSString *strurl=[url absoluteString];
    NSLog(@"html5Imageymf:::%@",strurl);
    if([strurl isEqualToString:@"about:blank"] || strurl == nil)
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        //        NSString *requestString = [[navigationAction.request URL] absoluteString];
        if ([strurl hasPrefix:@"jscall"]) {
            NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@":"];
            NSString *functionName = (NSString*)[urlComponents objectAtIndex:1];
            NSString *functionArgs = [(NSString*)[urlComponents objectAtIndex:2]
                                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSData *argsData = [functionArgs dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *argsDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:argsData options:kNilOptions error:NULL];
            //convert js array to objc array
            NSMutableArray *args = [NSMutableArray array];
            for (int i=0; i<[argsDic count]; i++) {
                [args addObject:[argsDic objectForKey:[NSString stringWithFormat:@"%d", i]]];
            }
            //ignore warning
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL selector = NSSelectorFromString([args count]>0?[functionName stringByAppendingString:@":"]:functionName);
            if ([self respondsToSelector:selector]) {
                [self performSelector:selector withObject:args];
            }
        }else{
//            if ([strurl containsString:@"index.html"]) {
//                self.isIndex = YES;
//                self.isLogin = NO;
//            }else if ([strurl containsString:@"login.html"]){
//                self.isLogin = YES;
//                self.isIndex = NO;
//            }else{
//                self.isIndex = NO;
//                self.isLogin = NO;
//            }
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
#pragma mark - Selector
//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.myProgressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.myProgressView.progress;
        [self.myProgressView setProgress:self.webView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.myProgressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.myProgressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Getter

- (UIProgressView *)myProgressView{
    if (!_myProgressView) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,3)];
        _myProgressView.progressViewStyle = UIProgressViewStyleBar;
    }
    return _myProgressView;
}

#pragma mark - Private
-(void)getVersion
{
    NSString *str=[NSString stringWithFormat:@"{\"value\":\"%@\",\"actionId\":\"getVersion\"}", CIVETVERSION];
    //NSString* jsStr=[NSString stringWithFormat:@"feedback(JSON.parse('%@'));",str];
    NSString* jsStr=[NSString stringWithFormat:@"feedback('%@');",str];
    //[self.webView stringByEvaluatingJavaScriptFromString:jsStr];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}
@end
