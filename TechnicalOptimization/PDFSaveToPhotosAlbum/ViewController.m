//
//  ViewController.m
//  SavePDFToPhotoAlbum
//
//  Created by 周泽文 on 2017/7/18.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "TestWKWebView.h"
#define PDFUrl @"http://ei-test.51fapiao.cn:9080/FPFX/actions/347013a4332ca1a32892dee3e0d598c47701c0"
#define PDFUrl2 @"http://ei-test.51fapiao.cn:9080/FPFX/actions/f13955a658e7a2c208ae08daa055d82b7391e6"

@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存pdf到相册中" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 200, 50)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
    [button addTarget:self action:@selector(savePDFPageToPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
   
    
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    _webView = [[UIWebView alloc] initWithFrame:frame];
    _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor cyanColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PDFUrl2]]];
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"推出下一级" forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(0, 0, 200, 50)];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
    [button2 addTarget:self action:@selector(pushNextView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}

-(void)pushNextView:(UIButton *)button{
    TestWKWebView * ctr = [[TestWKWebView alloc] init];
    [self.navigationController pushViewController:ctr animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
//        NSLog(@"webView:%@",NSStringFromCGSize(fittingSize));
//        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
//        _webView.scrollView.contentSize = fittingSize;
//        _webView.frame = CGRectMake(0, 64, fittingSize.width, fittingSize.height);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    CGFloat heigth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    CGRect frame = webView.frame;
//    frame.size.height = heigth;
//    webView.frame = frame;
//    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//    CGRect frame = webView.frame;
//    CGSize size = webView.scrollView.contentSize;
    
    CGFloat heigth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
    NSLog(@"%f",webView.pageLength);
    
//    webView.pageLength;
}
/**
 1 使用weakSelf 在用instruments调试的时候会闪退
 2 这里开启子线程操作pdf保存到photosAlbum时，
 后面子线程会一直开启导致cpu占用率100%，真机测试时机器发烫。
 */
-(void)savePDFPageToPhotoAlbum:(UIButton *)button{
    //    __weak typeof(self) weakSelf = self;
    //    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.zhouzewen.SavePDFPage", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_async(concurrentQueue, ^{
    NSString * pdfUrlStr = PDFUrl;
    NSURL * pdfUrl = [NSURL URLWithString:pdfUrlStr];
    
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((CFURLRef)pdfUrl);
    unsigned long pageAmount = CGPDFDocumentGetNumberOfPages(pdfRef);
    if (pageAmount > 0) {
        for (int i = 1; i < pageAmount + 1; i++) {
            
            CGPDFPageRef page = CGPDFDocumentGetPage(pdfRef, i);
            //                UIImage * image = [weakSelf getImageFromPDFPage:page];
            UIImage * image = [self getImageFromPDFPage:page];
            //                UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            //                dispatch_async(dispatch_get_main_queue(), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            //                });
            //                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
    CGPDFDocumentRelease(pdfRef);
    //    });
}
-(UIImage *)getImageFromPDFPage:(CGPDFPageRef)page{
    //保存图片的尺寸和原图pdf页面原图一样
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    
    UIGraphicsBeginImageContext(pageRect.size);
    
    CGContextRef imgContext = UIGraphicsGetCurrentContext();
    
    // 设置背景颜色
    CGContextSetRGBFillColor(imgContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(imgContext, pageRect);
    CGContextSaveGState(imgContext);
    
    
    /**
     iOS的坐标系原点在左上角，而物理坐标系在左下角，并且两者的Y轴反向
     所以要将iOS的坐标系转换为物理坐标系要做两步
     1 将坐标原点下移
     2 Y轴反向
     
     因为开始是iOS坐标系，所以要先下移pageRect.size.height 然后反转Y轴
     如果是先反转Y轴，那么下移的时候就是 -pageRect.size.height
     */
    
    CGContextTranslateCTM(imgContext, 0.0, pageRect.size.height);
    CGContextScaleCTM(imgContext, 1.0, -1.0);
    
    // 设置转成pdf图片的质量
    CGContextSetInterpolationQuality(imgContext, kCGInterpolationDefault);
    CGContextSetRenderingIntent(imgContext, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(imgContext, page);
    
    CGContextRestoreGState(imgContext);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void *)contextInfo{
    NSString * msg = nil;
    if (error != NULL)
        msg = @"失败";
    else
        msg = @"成功";
    
    UIAlertController * ctr = [UIAlertController alertControllerWithTitle:@"保存结果" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [ctr addAction:action];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [self presentViewController:ctr animated:YES completion:nil];
    //    });
    
}


@end
