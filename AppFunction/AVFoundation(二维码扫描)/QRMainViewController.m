//
//  QRMainViewController.m
//  QRCodeDemo
//
//  Created by c0ming on 10/30/15.
//  Copyright © 2015 c0ming. All rights reserved.
//
/**
 iOS二维码扫描,你需要注意的两件事 http://www.cocoachina.com/ios/20141225/10763.html
 
 */

#import "QRMainViewController.h"
#import <Photos/Photos.h>
@import CoreImage;

@interface QRMainViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation QRMainViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请去-> [设置 - 隐私 - 相机 - 摩宝网] 打开访问开关" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alertView show];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                // 放一些使用相册的代码
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)generateAction:(UIButton *)sender {
	[self.view endEditing:YES];

	NSString *QRCodeString = self.textField.text;
	if (![QRCodeString isEqualToString:@""]) {
		NSData *data = [QRCodeString dataUsingEncoding:NSUTF8StringEncoding];

		CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
		[filter setValue:data forKey:@"inputMessage"];
		CIImage *outputImage = filter.outputImage;

		CGFloat scale = CGRectGetWidth(self.imageView.bounds) / CGRectGetWidth(outputImage.extent);
		CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
		CIImage *transformImage = [outputImage imageByApplyingTransform:transform];

		self.imageView.image = [UIImage imageWithCIImage:transformImage];
        
        //把生成的二维码保存到相册中
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 2.1 创建一个相册变动请求
//                PHAssetCollectionChangeRequest *collectionRequest;
//
//                // 2.2 取出指定名称的相册
//                PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:collectionName];
//
//                // 2.3 判断相册是否存在
//                if (assetCollection) { // 如果存在就使用当前的相册创建相册请求
//                    collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//                } else { // 如果不存在, 就创建一个新的相册请求
//                    collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
//                }
//
//                // 2.4 根据传入的相片, 创建相片变动请求
//                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
//
//                // 2.4 创建一个占位对象
//                PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
//
//                // 2.5 将占位对象添加到相册请求中
//                [collectionRequest addAssets:@[placeholder]];
//            });
//
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            NSLog(@"success = %d, error = %@", success, error);
//        }];
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
//		CIContext *context = [CIContext contextWithOptions:nil];
//		CGImageRef imageRef = [context createCGImage:transformImage fromRect:transformImage.extent];
//		UIImage *QRCodeImage = [UIImage imageWithCGImage:imageRef];
//		[UIImagePNGRepresentation(QRCodeImage) writeToFile:path atomically:NO];
//		CGImageRelease(imageRef);

		self.textField.text = @"";
	} else {
		NSLog(@"QRCodeString is empty.");
	}
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [self showAlertViewWithMessage:msg];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
//    [self showViewController:alert sender:nil];
}

- (void)showAlertViewWithMessage:(NSString *)message {
    NSLog(@"%@", message);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.delegate = self;
    [alertView show];
}

@end
