//
//  UIButton+Action.h
//  ButtonActionWithRuntime
//
//  Created by CivetDev on 2017/6/12.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ActionBlock)(UIButton *button) ;
@interface UIButton (Action)
@property (nonatomic , copy) ActionBlock actionBlock ;
+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title actionBlock:(ActionBlock)actionBlock ;
@end
