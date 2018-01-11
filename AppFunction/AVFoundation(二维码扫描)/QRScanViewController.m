//
//  QRScanViewController.m
//  QRCodeDemo
//
//  Created by c0ming on 10/30/15.
//  Copyright © 2015 c0ming. All rights reserved.
//

/**
 参考资料
 https://www.jianshu.com/p/33a672d98273
 
 */
#import "QRScanViewController.h"
#import "QRScanView.h"
#import "ZZW_ScanView.h"
@import AVFoundation;

@interface QRScanViewController () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, assign) BOOL isQRCodeCaptured;
@property (nonatomic, strong) ZZW_ScanView *scanView;

@end

@implementation QRScanViewController
#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}



#pragma mark - Actions

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickAction:(UIBarButtonItem *)sender {
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
//	imagePickerController.allowsEditing = YES;
	[self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - Setup

- (void)setup {
	AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	switch (authorizationStatus) {
		case AVAuthorizationStatusNotDetermined: {
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
			    if (granted) {
			        [self setupCapture];
				} else {
			        NSLog(@"%@", @"访问受限");
				}
			}];
			break;
		}

		case AVAuthorizationStatusAuthorized: {
			[self setupCapture];
			break;
		}

		case AVAuthorizationStatusRestricted:
		case AVAuthorizationStatusDenied: {
			NSLog(@"%@", @"访问受限");
			break;
		}

		default: {
			break;
		}
	}
    CGFloat width = 0.7 * self.view.frame.size.width;
    CGFloat x = 0.5 * (1 - 0.7) * self.view.frame.size.width;
    CGFloat y = 0.5 * ((self.view.frame.size.height * 0.9) - width);
    
	self.scanRect = CGRectMake(x, y, width, width);
}

- (void)setupCapture {
	dispatch_async(dispatch_get_main_queue(), ^{
		AVCaptureSession *session = [[AVCaptureSession alloc] init];
		AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		NSError *error;
		AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
		if (deviceInput) {
		    [session addInput:deviceInput];

		    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
		    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
		    [session addOutput:metadataOutput]; // 这行代码要在设置 metadataObjectTypes 前
		    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

		    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
		    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		    previewLayer.frame = self.view.frame;
		    [self.view.layer insertSublayer:previewLayer atIndex:0];

		    __weak typeof(self) weakSelf = self;
		    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
		                                                      object:nil
		                                                       queue:[NSOperationQueue currentQueue]
		                                                  usingBlock: ^(NSNotification *_Nonnull note) {
                metadataOutput.rectOfInterest = [previewLayer metadataOutputRectOfInterestForRect:weakSelf.scanRect]; // 如果不设置，整个屏幕都可以扫
			}];
            self.scanView = [[ZZW_ScanView alloc] initWithScanRect:self.scanRect scanViewFrame:self.view.frame];
            [self.view addSubview:self.scanView];
            [self.scanView addTimer];
            

		    [session startRunning];
		} else {
		    NSLog(@"%@", error);
		}
	});
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
	AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
	if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode] && !self.isQRCodeCaptured) {
		self.isQRCodeCaptured = YES;
        [self.scanView removeTimer];
		[self showAlertViewWithMessage:metadataObject.stringValue];
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];

	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy:CIDetectorAccuracyHigh }];
	CIImage *image = [[CIImage alloc] initWithImage:originalImage];
	NSArray *features = [detector featuresInImage:image];
	CIQRCodeFeature *feature = [features firstObject];
	if (feature) {
		[self showAlertViewWithMessage:feature.messageString];
		[picker dismissViewControllerAnimated:YES completion:nil];
	} else {
		NSLog(@"没有二维码");
		[picker dismissViewControllerAnimated:YES completion:NULL];
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	self.isQRCodeCaptured = NO;
    [self.scanView addTimer];
}

#pragma mark - Private Methods

- (void)showAlertViewWithMessage:(NSString *)message {
	NSLog(@"%@", message);

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	alertView.delegate = self;
	[alertView show];
}


@end
