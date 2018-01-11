//
//  ZZW_ScanView.h
//  AVFoundation(二维码扫描)
//
//  Created by 周泽文 on 2018/1/10.
//  Copyright © 2018年 zhouzewen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CornerLoactionDefault,/// 默认与边框线同中心点
    CornerLoactionInside,/// 在边框线内部
    CornerLoactionOutside,/// 在边框线外部
} CornerLoaction;

@interface ZZW_ScanView : UIView
@property (nonatomic, copy) NSString *scanningImageName;// 扫描线名字
@property (nonatomic, strong) UIColor *borderColor;// 边框颜色，默认白色
@property (nonatomic, strong) UIColor *cornerColor;// 边角颜色，默认微信颜色
@property (nonatomic, assign) CGFloat cornerWidth;// 边角宽度，默认 2.f
@property (nonatomic, assign) CGFloat backgroundAlpha;// 扫描区周边颜色的 alpha 值，默认 0.2f
@property (nonatomic, assign) NSTimeInterval animationTimeInterval;// 扫描线动画时间，默认 0.02
@property (nonatomic, assign) CornerLoaction cornerLocation;// 边角位置
- (void)addTimer;// 添加定时器
- (void)removeTimer;// 移除定时器
- (instancetype)initWithScanRect:(CGRect)rect scanViewFrame:(CGRect)frame;
@end
