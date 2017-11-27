//
//  Zzw_SuspendBallButton.h
//  SuspendBall
//
//  Created by 周泽文 on 2017/7/24.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Zzw_SuspendBallButton;
@protocol Zzw_SuspendBallButtonDelegate<NSObject>
-(void)clickButton:(Zzw_SuspendBallButton *)button;
@end

@interface Zzw_SuspendBallButton : UIButton

+(instancetype)sharedInstance;


/**
 imagePath usage
 if your image in Assets.xcassets , you should pass path param  use @"name"
 but if your is in a bundle , you should use [[NSBundle mainBundle] pathForResource:@"name" ofType:@"type"] or other bundle path
 */
- (instancetype)suspendBallWithFrame:(CGRect)ballFrame
                            delegate:(id<Zzw_SuspendBallButtonDelegate>)delegate
                   subBallImagePath:(NSString *)path;


@property (nonatomic, weak) id<Zzw_SuspendBallButtonDelegate> delegate;


@property (nonatomic ,assign,readwrite) BOOL shouldStickToScreen;/** 松开悬浮球后是否需要黏在屏幕的左右两端  */
@end
