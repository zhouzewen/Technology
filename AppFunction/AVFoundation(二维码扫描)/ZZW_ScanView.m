//
//  ZZW_ScanView.m
//  AVFoundation(二维码扫描)
//
//  Created by 周泽文 on 2018/1/10.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import "ZZW_ScanView.h"
// 扫描内容的 W 值
#define scanBorderW 0.7 * self.frame.size.width
// 扫描内容的 x 值
#define scanBorderX 0.5 * (1 - 0.7) * self.frame.size.width
// 扫描内容的 Y 值
#define scanBorderY 0.5 * ((self.frame.size.height * 0.9) - scanBorderW)

@interface ZZW_ScanView()
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *scanningline;
@end
@implementation ZZW_ScanView
- (instancetype)initWithScanRect:(CGRect)rect scanViewFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _scanRect = rect;
        _borderColor = [UIColor whiteColor];
        _cornerColor = [UIColor colorWithRed:85/255.0f green:183/255.0 blue:55/255.0 alpha:1.0];
        _cornerWidth = 2.0;
        _backgroundAlpha = 0.5;
        _animationTimeInterval = 0.02;
        _cornerLocation = CornerLoactionDefault;
        _scanningImageName = @"QRCodeScanningLine";
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
    
    CGMutablePathRef screenPath = CGPathCreateMutable();
    CGPathAddRect(screenPath, NULL, self.bounds);
    
    CGMutablePathRef scanPath = CGPathCreateMutable();
    CGPathAddRect(scanPath, NULL, self.scanRect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddPath(path, NULL, screenPath);
    CGPathAddPath(path, NULL, scanPath);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    CGPathRelease(screenPath);
    CGPathRelease(scanPath);
    CGPathRelease(path);
    
    
    // 边框 frame
    CGFloat borderW = scanBorderW;
    CGFloat borderH = borderW;
    CGFloat borderX = scanBorderX;
    CGFloat borderY = scanBorderY;
    CGFloat borderLineW = 0.2;
    
    // 空白区域设置
    [[[UIColor blackColor] colorWithAlphaComponent:self.backgroundAlpha] setFill];
    UIRectFill(rect);
    // 获取上下文，并设置混合模式 -> kCGBlendModeDestinationOut
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    // 设置空白区 用来扫描
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX + 0.5 * borderLineW, borderY + 0.5 *borderLineW, borderW - borderLineW, borderH - borderLineW)];
    [bezierPath fill];
    // 执行混合模式
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    /// 边框设置
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(borderX, borderY, borderW, borderH)];
    borderPath.lineCapStyle = kCGLineCapButt;
    borderPath.lineWidth = borderLineW;
    [self.borderColor set];
    [borderPath stroke];
    
    
    CGFloat cornerLenght = 20;
    /// 左上角小图标
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    leftTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    CGFloat insideExcess = fabs(0.5 * (self.cornerWidth - borderLineW));
    CGFloat outsideExcess = 0.5 * (borderLineW + self.cornerWidth);
    if (self.cornerLocation == CornerLoactionInside) {
        [leftTopPath moveToPoint:CGPointMake(borderX + insideExcess, borderY + cornerLenght + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght + insideExcess, borderY + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftTopPath moveToPoint:CGPointMake(borderX - outsideExcess, borderY + cornerLenght - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght - outsideExcess, borderY - outsideExcess)];
    } else {
        [leftTopPath moveToPoint:CGPointMake(borderX, borderY + cornerLenght)];
        [leftTopPath addLineToPoint:CGPointMake(borderX, borderY)];
        [leftTopPath addLineToPoint:CGPointMake(borderX + cornerLenght, borderY)];
    }
    
    [leftTopPath stroke];
    
    /// 左下角小图标
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    leftBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX + insideExcess, borderY + borderH - cornerLenght - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX - outsideExcess, borderY + borderH - cornerLenght + outsideExcess)];
    } else {
        [leftBottomPath moveToPoint:CGPointMake(borderX + cornerLenght, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH)];
        [leftBottomPath addLineToPoint:CGPointMake(borderX, borderY + borderH - cornerLenght)];
    }
    
    [leftBottomPath stroke];
    
    /// 右上角小图标
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + cornerLenght + insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + cornerLenght - outsideExcess)];
    } else {
        [rightTopPath moveToPoint:CGPointMake(borderX + borderW - cornerLenght, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY)];
        [rightTopPath addLineToPoint:CGPointMake(borderX + borderW, borderY + cornerLenght)];
    }
    
    [rightTopPath stroke];
    
    /// 右下角小图标
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    rightBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLoactionInside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - cornerLenght - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - insideExcess, borderY + borderH - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght - insideExcess, borderY + borderH - insideExcess)];
    } else if (self.cornerLocation == CornerLoactionOutside) {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH - cornerLenght + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW + outsideExcess, borderY + borderH + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght + outsideExcess, borderY + borderH + outsideExcess)];
    } else {
        [rightBottomPath moveToPoint:CGPointMake(borderX + borderW, borderY + borderH - cornerLenght)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW, borderY + borderH)];
        [rightBottomPath addLineToPoint:CGPointMake(borderX + borderW - cornerLenght, borderY + borderH)];
    }
    
    [rightBottomPath stroke];
}
#pragma mark - - - get
- (UIImageView *)scanningline {
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    if (!_scanningline) {
        _scanningline = [[UIImageView alloc] init];
        _scanningline.image = [UIImage imageNamed:self.scanningImageName];
    }
    return _scanningline;
}

#pragma mark - - - 添加定时器
- (void)addTimer {
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    CGFloat scanninglineX = 0;
    CGFloat scanninglineY = 0;
    CGFloat scanninglineW = 0;
    CGFloat scanninglineH = 0;
    [self addSubview:self.scanningline];
    scanninglineW = scanBorderW;
    scanninglineH = 12;
    scanninglineX = scanBorderX;
    scanninglineY = scanBorderY;
    _scanningline.frame = CGRectMake(scanninglineX, scanninglineY, scanninglineW, scanninglineH);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationTimeInterval target:self selector:@selector(beginTimer) userInfo:nil repeats:YES];
}
#pragma mark - - - 移除定时器
- (void)removeTimer {
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    [self.timer invalidate];
    self.timer = nil;
    [self.scanningline removeFromSuperview];
    self.scanningline = nil;
    NSLog(@"移除定时器");
}
#pragma mark - - - 执行定时器方法
- (void)beginTimer {
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    __block  CGRect frame = _scanningline.frame;
    [UIView animateWithDuration:self.animationTimeInterval animations:^{
        frame.origin.y = 2 + frame.origin.y;
        _scanningline.frame = frame;
    } completion:^(BOOL finished) {
        if (_scanningline.frame.origin.y >= scanBorderY + scanBorderW-10) {
            frame.origin.y = scanBorderY;
            _scanningline.frame = frame;
        }
    }];
}
@end
