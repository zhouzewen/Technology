//
//  ViewController.m
//  AVFoundation(二维码扫描)
//
//  Created by 周泽文 on 2018/1/8.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#define ScanViewWidth 300
#define ButtonWidth 200
#define ViewSize self.view.frame.size
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic,strong) UIView *photoView;

@property(nonatomic,assign) BOOL isLightOn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat x = (ViewSize.width - ButtonWidth*2)/3;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(x, 100 + 300 + 100, ButtonWidth, 50)];
    [button setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickedLightUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(x*2 + ButtonWidth, 100 + 300 + 100, ButtonWidth, 50)];
    [button2 setTitle:@"开始扫描" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(startScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

-(void)startScan{
    // 获取手机硬件设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    _captureSession = [[AVCaptureSession alloc] init];// 创建会话
    
    [_captureSession addInput:input];// 添加输入流
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];// 初始化输出流
    
    [_captureSession addOutput:output];// 添加输出流
    // 创建dispatch queue
    dispatch_queue_t queue = dispatch_queue_create("com.zhouzewen.queue", DISPATCH_QUEUE_CONCURRENT);
    //扫描的结果苹果是通过代理的方式区回调，所以outPut需要添加代理，并且因为扫描是耗时的工作，所以把它放到子线程里面
    [output setMetadataObjectsDelegate:self queue:queue];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];// 设置支持二维码和条形码扫描
    // 创建输出对象
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    _previewLayer.frame = self.view.bounds;
    _previewLayer.frame = CGRectMake(ViewSize.width/2 - ScanViewWidth/2, 100, ScanViewWidth, ScanViewWidth);
//    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    _photoView = [[UIView alloc] initWithFrame:_previewLayer.frame];
    _previewLayer.frame = CGRectMake(0, 0, ScanViewWidth, ScanViewWidth);
    [_photoView.layer addSublayer:_previewLayer];
    [self.view addSubview:_photoView];
    
//    [self.view.layer addSublayer:_previewLayer];
    // 开始会话
    [_captureSession startRunning];
}


// 结束扫描
- (void)stopScan {
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        // 扫描到之后，停止扫描
        [self stopScan];
        // 获取结果并对其进行处理
        dispatch_async(dispatch_get_main_queue(), ^{
            AVMetadataMachineReadableCodeObject *object = metadataObjects.firstObject;
            if ([[object type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                NSString *result = object.stringValue;
               UILabel * resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 600, 350, 50)];
                resultLabel.font = [UIFont systemFontOfSize:14];
                resultLabel.text = result;
                [resultLabel sizeToFit];
                resultLabel.frame = CGRectMake(ViewSize.width/2 - resultLabel.frame.size.width/2, 600, resultLabel.frame.size.width, 50);
                [self.view addSubview:resultLabel];
                
                // 处理result
                NSLog(@"%@",result);
                
                //将扫描到的二维码保存到相册
                [self saveViewToPhotoAlbum];
                
            } else {
                NSLog(@"不是二维码");
            }
        });
    }
}
-(void)saveViewToPhotoAlbum{
    CGRect rect = CGRectMake(0, 0, ScanViewWidth, ScanViewWidth);
    UIGraphicsBeginImageContextWithOptions(_photoView.bounds.size, NO, [UIScreen mainScreen].scale);
    [_photoView drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    [_previewLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void  *)contextInfo{
    if (error == nil) {
        NSLog(@"存入手机相册成功");
    }else{
        NSLog(@"存入手机相册失败");
    }
}

// 开启和关闭闪光灯
- (void)didClickedLightUpButton:(UIButton *)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //判断手机是否有闪光灯
    if ([device hasTorch]) {
        //呼叫手机操作系统，控制手机硬件
        NSError *error = nil;
        [device lockForConfiguration:&error];
        if (self.isLightOn == NO) {
            [device setTorchMode:AVCaptureTorchModeOn];
            self.isLightOn = YES;
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            self.isLightOn = NO;
        }
        //结束对硬件的控制，跟上面的lockForConfiguration是配对的API
        [device unlockForConfiguration];
    }
}


@end
