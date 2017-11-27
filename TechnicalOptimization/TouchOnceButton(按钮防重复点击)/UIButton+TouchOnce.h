//
//  UIButton+TouchOnce.h
//  TouchOnceButton(按钮防重复点击)
//
//  Created by 周泽文 on 2017/11/10.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval 5
@interface UIButton (TouchOnce)
@property(nonatomic,assign)NSTimeInterval timeInterval;
@property(nonatomic,assign)BOOL isIgnoreEvent;
@end
